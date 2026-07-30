# AI Usage Log

Record at least one point where you used an AI coding assistant (ChatGPT, Claude, Cursor, GitHub Copilot, Gemini, etc.) during this assignment.

## Interaction 1

- **Tool used:** ChatGPT
- **Task / Problem:** Debugging the Databricks HTTP path being incorrectly converted by Git Bash.
- **Prompt sent:**
  > `i got this error

Connection:
00:21:33 host: **\*\*\*\***\*\***\*\*\*\***\***\*\*\*\***\*\***\*\*\*\***
00:21:33 http_path: C:/Program Files/Git/sql/1.0**\*\***\*\*\*\***\*\***
00:21:33 catalog: hyf
00:21:33 schema: dev_mohammedalfakih
00:21:33 Registered adapter: databricks=1.12.3
00:21:34 Databricks adapter: SPOG host (host_type='workspace'): no
00:21:34 Databricks adapter: workspace_id (from ?o= in http_path): None
00:21:34 Databricks adapter: databricks-sql-connector version: 4.3.0 (supported)
00:21:34 Databricks adapter: databricks-sdk version: 0.117.0 (supported)
00:21:34 databricks-sql-connector adapter: ThriftBackend.attempt_request: Exception: %s
ERROR:databricks.sql.backend.thrift_backend:ThriftBackend.attempt_request: Exception:
00:21:34 Databricks adapter: Connection(session-id=Unknown) - Exception while trying to create connection: Error during request to server.
Error properties: attempt=1/30, bounded-retry-delay=None, elapsed-seconds=0.10899758338928223/900.0, error-message=, http-code=404, method=OpenSession, no-retry-reason=non-retryable error, original-exception=, query-id=None, session-id=None
00:21:34 Connection test: [ERROR]

00:21:34 1 check failed:
00:21:34 dbt was unable to connect to the specified database.
The database returned the following error:

> Database Error
> Database Error

    Error during request to server.

Check your database credentials and try again. For more information, visit:
https://docs.getdbt.com/docs/configure-your-profile

---

i notice that http path is loaded in wrong way. i have if in my .env as DATABRICKS_HTTP_PATH=/sql/1.0/warehouses/**\*\*\*\***\*\*\***\*\*\*\***
but in the error i can see http_path: C:/Program Files/Git/sql/1.0**\*\***\*\*\*\***\*\***
can u explain why is this happing and how to solve it.
note: the(\*) is only to hide secrets so I have an real values in my .env`

- **Output provided by AI:**
  > `You found the cause correctly. Git Bash uses MSYS2, which automatically converts environment-variable values that look like Unix paths before passing them to native Windows programs. Therefore:
/sql/1.0/warehouses/...
was incorrectly converted to:
C:/Program Files/Git/sql/1.0/warehouses/...
That produced the HTTP 404. MSYS2 documents this environment-variable path conversion.
Keep the value in .env unchanged—it is correct.
Next step only
In the same Git Bash session, run:
export MSYS2_ENV_CONV_EXCL=DATABRICKS_HTTP_PATH
uv run dbt debug --profiles-dir .
This tells Git Bash not to convert that specific environment variable. The debug output should now show an HTTP path beginning with:
/sql/1.0/warehouses/
and ideally finish with:
All checks passed!
`
- **What I kept, changed, or rejected, and why:**
  > `I kept the suggested `MSYS2_ENV_CONV_EXCL=DATABRICKS_HTTP_PATH`fix because it prevented Git Bash from converting the Databricks HTTP path, and`dbt debug`then passed. I kept the correct`/sql/1.0/warehouses/...` value unchanged and did not include any real token or credential in the AI prompt.`

_(Ensure no personal passwords, Databricks tokens, or unapproved credentials are included in prompts or logged outputs.)_
