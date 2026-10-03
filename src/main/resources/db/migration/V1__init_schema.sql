-- V1: core tables. The embedding column + vector index come in V2 once the
-- embedding model (and therefore its dimension) is chosen.
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE collection (
    id         UUID PRIMARY KEY,
    name       VARCHAR(200) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE document (
    id            UUID PRIMARY KEY,
    collection_id UUID         NOT NULL REFERENCES collection (id) ON DELETE CASCADE,
    filename      VARCHAR(500) NOT NULL,
    content_type  VARCHAR(100) NOT NULL,
    size_bytes    BIGINT       NOT NULL,
    content_hash  CHAR(64)     NOT NULL,           -- SHA-256, used for duplicate detection
    status        VARCHAR(20)  NOT NULL,           -- UPLOADED | PROCESSING | READY | FAILED
    error_message TEXT,
    page_count    INTEGER,
    chunk_count   INTEGER      NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    processed_at  TIMESTAMPTZ,
    UNIQUE (collection_id, content_hash)
);

CREATE TABLE chunk (
    id            UUID PRIMARY KEY,
    document_id   UUID    NOT NULL REFERENCES document (id) ON DELETE CASCADE,
    chunk_index   INTEGER NOT NULL,                -- order within the document
    content       TEXT    NOT NULL,                -- original text, used for citations
    heading_path  TEXT,                            -- e.g. "Auth > Tokens > Expiry"
    page_start    INTEGER,
    page_end      INTEGER,
    char_start    INTEGER,
    char_end      INTEGER,
    token_count   INTEGER,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (document_id, chunk_index)
);

CREATE INDEX idx_chunk_document ON chunk (document_id);
