# ADR 0001: Stack and constraints

**Context:** Portfolio project; must be free and light on a 16 GB laptop (no local Docker/models).

**Decisions**
- Modular monolith (packages + ArchUnit later), not microservices: one deployable, easy to test.
- Neon Postgres + pgvector as source of truth; Flyway owns schema, Hibernate runs in `validate` mode.
- JPA for all data access (native queries only where vector search needs them).
- Lucene embedded for real BM25; it is a derived index rebuilt from Postgres. OpenSearch is the same engine behind REST, so it can replace it behind `LexicalRetriever`.
- Hosted free APIs (called from Java) for embeddings, reranking, LLM; all behind interfaces and cached.
- Plain HTML/JS/Bootstrap UI served from `src/main/resources/static`.

**Consequences:** needs internet to develop; free-tier limits are a risk (mitigated by caching and swappable providers); documents are sent to third parties, so use public/synthetic docs only.
