"""Local CLI bridge: installed dbt-snowflake does not expose passcode in YAML."""
import getpass
import os
import sys
import threading

from dbt.adapters.snowflake.connections import SnowflakeCredentials
from dbt.cli.main import cli


def configure_mfa(method):
    if method not in ('totp', 'duo'):
        raise ValueError('Choose totp or duo.')
    original = SnowflakeCredentials.auth_args
    prompt_lock = threading.Lock()

    def auth_args(credentials):
        args = original(credentials)
        # Keep this launcher from persisting authentication tokens to Keychain.
        args['client_store_temporary_credential'] = False
        args['client_request_mfa_token'] = False
        # On macOS username_password_mfa forces cache access despite those flags.
        # Native password authentication still sends PASSCODE and enforces server MFA.
        args['authenticator'] = 'snowflake'
        if method == 'totp':
            with prompt_lock:
                if not sys.stdin.isatty():
                    raise RuntimeError('MFA codes must be entered in a real terminal.')
                code = getpass.getpass('Current 6-digit authenticator code (hidden; use a fresh code): ').strip()
                if len(code) != 6 or not code.isascii() or not code.isdigit():
                    raise ValueError('Expected a six-digit code; no connection attempted.')
                # Also register the code with dbt secret scrubbing for this process.
                os.environ['DBT_ENV_SECRET_CONFIDO_MFA_CODE'] = code
                args['passcode'] = code
        return args

    SnowflakeCredentials.auth_args = auth_args


if __name__ == '__main__':
    configure_mfa(os.environ['CONFIDO_MFA_METHOD'])
    try:
        cli()
    finally:
        os.environ.pop('DBT_ENV_SECRET_CONFIDO_MFA_CODE', None)
