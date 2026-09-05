%{
title: "RAG é não é um prompt: arquitetura de software para IA robusta",
event: "SCTI",
location: "UENF",
date: ~D[2026-09-02],
image: "/images/talks/eu-palestra.png",
repo: "https://github.com/zoedsoupe/scti-2026-palestra",
slides: "https://github.com/zoedsoupe/scti-2026-palestra/blob/main/slides-export.pdf",
}
---

A tese: RAG não é um prompt, é um sistema. O que faz sobreviver à produção é arquitetura: functional core, imperative shell. Tudo que é contado aqui aconteceu em dois sistemas reais:

- **JIM**, o assistente financeiro dentro do app da Infinite Pay (100 mil+ usuários por dia). Backend Elixir/BEAM, embeddings locais via Bumblebee (nenhuma API externa de embedding, texto interno não sai da infra), e orquestração das features dos outros times expostas via MCP.
- **new-gen.ai**, plataforma de base de conhecimento. Aqui o problema vem um passo antes de responder: a base precisa nascer do zero. Um ciclo com aprovação humana, onde cada afirmação gerada carrega uma **lineage edge** apontando pro chunk fonte, conferida por um validador determinístico entre duas chamadas de LLM.
