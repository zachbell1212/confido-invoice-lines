"""Build the invoice DAG from a private interactive terminal."""
import getpass
import os
from pathlib import Path
import subprocess
import sys

project = Path(__file__).resolve().parents[1]

if not sys.stdin.isatty():
    sys.exit('Run in an interactive terminal for private authentication.')
env = os.environ.copy()
key = 'DBT_ENV_SECRET_CONFIDO_SNOWFLAKE_PASSWORD'
env[key] = getpass.getpass('Confido Snowflake password (hidden): ')
if not env[key]:
    sys.exit('No password entered; nothing connected.')
env['CONFIDO_MFA_METHOD'] = 'totp'
env['DBT_SEND_ANONYMOUS_USAGE_STATS'] = 'false'
try:
    result = subprocess.run([
        sys.executable,
        str(project / 'scripts/dbt_with_mfa.py'), '--no-use-colors',
        'build', '--threads', '1', '--select', '+invoice_lines',
        '--project-dir', str(project), '--profiles-dir', str(project / '.profiles')
    ], env=env, cwd=project)
    print('INVOICE BUILD PASSED.' if result.returncode == 0 else 'INVOICE BUILD FAILED. See errors above.')
    sys.exit(result.returncode)
finally:
    env.pop(key, None)
