-- +migrate Down
DROP TRIGGER IF EXISTS set_timestamp ON t_workspace;
DROP TRIGGER IF EXISTS set_timestamp ON t_user;
-- DROP TRIGGER IF EXISTS set_timestamp ON t_user_process;

DROP FUNCTION IF EXISTS trigger_set_timestamp();
DROP TABLE IF EXISTS t_workspace, t_user, t_notion;

-- +migrate Up
CREATE TABLE t_workspace (
    id varchar(255) PRIMARY KEY,
    name varchar(255) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

-- administoratorはこのアプリの中で一人のみ
CREATE TABLE t_user (
    id serial PRIMARY KEY,
    slack_user_id varchar(255) NOT NULL UNIQUE,
    t_workspace_id varchar(255) NOT NULL,
    is_administrator boolean NOT NULL,
    name varchar(255) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp,
    FOREIGN KEY (t_workspace_id) REFERENCES t_workspace (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE t_notion (
    id serial PRIMARY KEY,
    t_user_id integer NOT NULL UNIQUE,
    date smallint NOT NULL,
    notion_token bytea NOT NULL,
    notion_database_id bytea NOT NULL,
    notion_page_content text,
    FOREIGN KEY (t_user_id) REFERENCES t_user (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- +migrate StatementBegin
CREATE FUNCTION trigger_set_timestamp() RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = NOW();
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;
-- +migrate StatementEnd

CREATE TRIGGER set_timestamp
    BEFORE UPDATE ON t_workspace
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp
    BEFORE UPDATE ON t_user
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();