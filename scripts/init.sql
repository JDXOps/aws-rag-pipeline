CREATE EXTENSION  vector IF NOT EXISTS;
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    embedding vector(1024),
    document TEXT,
    metadata JSONB
);