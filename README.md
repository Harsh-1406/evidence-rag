# Evidence-Driven Hybrid RAG

RAG that doesn't blindly trust retrieval or the LLM: hybrid retrieval (vector + BM25),
cross-encoder reranking, grounded answers, and per-claim citation verification.

**Status:** Module 1 in progress (foundation + ingestion).

## Run locally
1. Create a free Neon Postgres project; copy `.env.example` to `.env` and fill in the JDBC URL/user/password.
2. `./mvnw spring-boot:run`
3. Check `http://localhost:8080/actuator/health` shows `UP` (including `db`).

Stack: Java 21, Spring Boot, JPA/Hibernate, Flyway, Neon Postgres + pgvector, Lucene (BM25), hosted free embedding/rerank/LLM APIs.
See `docs/adr/` for decisions.
