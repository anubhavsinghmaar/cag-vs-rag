# RAG vs CAG — Live Comparison Tool

[![Live Demo](https://img.shields.io/badge/Live_Demo-00d4aa?style=for-the-badge&logo=netlify&logoColor=white)](https://cag-vs-rag.netlify.app)
[![Open In Colab](https://img.shields.io/badge/Open_in_Colab-F9AB00?style=for-the-badge&logo=googlecolab&logoColor=white)](https://colab.research.google.com/github/anubhavsinghmaar/rag-vs-cag/blob/main/notebook/RAG_vs_CAG_Demo.ipynb)
[![Gemini API](https://img.shields.io/badge/Powered_by-Gemini_3_Flash-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://aistudio.google.com)

> Same model. Same data. Different architecture. Completely different results.

A hands-on tool that runs **Retrieval Augmented Generation (RAG)** and **Cache Augmented Generation (CAG)** side by side on your own data, with real-time latency tracking, answer quality scoring, and a full comparison dashboard.

**Zero backend. Zero cost. Everything runs in your browser.**

![RAG vs CAG Screenshot](assets/screenshot.png)

---

## What Is This?

LLMs hallucinate when they don't have the right context. Two architectures solve this differently:

```
┌─────────────────────────────────────────────────────────────────┐
│                        YOUR KNOWLEDGE BASE                      │
│                  (internal docs, product specs, etc.)            │
└──────────────────────┬──────────────────────┬───────────────────┘
                       │                      │
              ┌────────▼────────┐    ┌────────▼────────┐
              │       RAG       │    │       CAG       │
              │                 │    │                 │
              │  Chunk document │    │  Load ENTIRE    │
              │  ↓              │    │  document into  │
              │  Embed chunks   │    │  context window │
              │  ↓              │    │  ↓              │
              │  Store in       │    │  Send question  │
              │  vector DB      │    │  + full doc     │
              │  ↓              │    │  to LLM         │
              │  Retrieve top   │    │                 │
              │  matching chunks│    │                 │
              │  ↓              │    │                 │
              │  Send chunks    │    │                 │
              │  + question     │    │                 │
              │  to LLM         │    │                 │
              └────────┬────────┘    └────────┬────────┘
                       │                      │
                       ▼                      ▼
              ┌─────────────────────────────────────────┐
              │              ANSWER + METRICS            │
              │    latency · relevance · word count      │
              └─────────────────────────────────────────┘
```

---

## Architecture Deep Dive

### RAG (Retrieval Augmented Generation)

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌───────────┐
│ Document │───▶│ Text Chunker │───▶│  Embedding   │───▶│  Vector   │
│          │    │ (120 words,  │    │  Model       │    │  Store    │
│          │    │  25 overlap) │    │ (text-embed  │    │ (in-mem)  │
└──────────┘    └──────────────┘    │  -ding-004)  │    └─────┬─────┘
                                    └──────────────┘          │
                                                              │
┌──────────┐    ┌──────────────┐    ┌──────────────┐          │
│ Question │───▶│   Embed      │───▶│  Cosine      │◀─────────┘
│          │    │   Query      │    │  Similarity   │
└──────────┘    └──────────────┘    │  Search      │
                                    └──────┬───────┘
                                           │ Top 3 chunks
                                    ┌──────▼───────┐    ┌───────────┐
                                    │   Prompt     │───▶│  Gemini   │───▶ Answer
                                    │  (chunks +   │    │  3 Flash  │
                                    │   question)  │    └───────────┘
                                    └──────────────┘
```

**Metrics tracked:** Embedding time, retrieval time, generation time, similarity scores, chunks used.

### CAG (Cache Augmented Generation)

```
┌──────────────────────┐
│    Full Document     │──────┐
│    (all content)     │      │
└──────────────────────┘      │
                              ├───▶ ┌───────────┐
┌──────────────────────┐      │     │  Gemini   │───▶ Answer
│      Question        │──────┘     │  3 Flash  │
│                      │            │           │
└──────────────────────┘            │  (reads   │
                                    │  everything│
                                    │  in one    │
                                    │  pass)     │
                                    └───────────┘
```

**Metrics tracked:** Total latency, context size, answer quality.

**Why CAG works now:** Gemini 3 Flash supports a massive context window. Your entire internal knowledge base can fit in a single prompt.

---

## Live Demo Features

| Feature | Description |
|---------|-------------|
| **Three-way comparison** | Baseline (hallucination) vs RAG vs CAG on every question |
| **Real-time latency** | Millisecond-level timing for every pipeline stage |
| **RAG breakdown** | Embedding time + retrieval time + generation time shown separately |
| **Similarity scores** | See the cosine similarity of each retrieved chunk |
| **Answer quality** | Keyword relevance scoring for every response |
| **History tracker** | Every question builds a comparison database |
| **JSON export** | Download all comparison data for further analysis |
| **Zero backend** | Everything runs client-side. Your API key stays in browser memory |

---

## Comparison Matrix

| | **Baseline** | **RAG** | **CAG** |
|---|---|---|---|
| **Context provided** | None | Top K chunks | Full document |
| **Retrieval step** | No | Yes (semantic search) | No |
| **Vector DB needed** | No | Yes | No |
| **Embedding model** | No | Yes | No |
| **Hallucination risk** | Very high | Low (if right chunks) | Very low |
| **Missed context risk** | N/A | Medium (wrong chunks) | None |
| **Setup complexity** | Zero | Medium | Zero |
| **Latency profile** | Fast (no context) | Medium (embed + retrieve + generate) | Varies (large prompt) |
| **Scales to 100s of docs** | N/A | Yes | No (context window cap) |
| **Best for** | Nothing useful | Large knowledge bases | Small to medium knowledge bases |

---

## When To Use Which

```
                    How big is your knowledge base?
                              │
                 ┌────────────┼────────────┐
                 │                         │
          Fits in context              Too large
          (< 1M tokens)            (100s of documents)
                 │                         │
                 ▼                         ▼
          ┌──────────┐              ┌──────────┐
          │   CAG    │              │   RAG    │
          │          │              │          │
          │ Simpler  │              │ Scalable │
          │ No infra │              │ Precise  │
          │ Full     │              │ Source   │
          │ context  │              │ tracking │
          └──────────┘              └──────────┘
```

**Use both when:** RAG retrieves candidate documents → CAG processes them with full context. This is where production systems are heading.

---

## Quick Start

### Option 1: Live Demo (No Code)

1. Visit the [live demo](https://cag-vs-rag.netlify.app)
2. Get a free API key from [Google AI Studio](https://aistudio.google.com/apikey)
3. Paste your knowledge base (or use the sample)
4. Ask questions and watch the comparison

### Option 2: Google Colab (Python)

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/anubhavsinghmaar/rag-vs-cag/blob/main/notebook/RAG_vs_CAG_Demo.ipynb)

The notebook includes:
- Full RAG pipeline (Sentence Transformers + ChromaDB)
- Basic CAG (full document in prompt)
- True CAG with Gemini Context Caching (KV Cache API)
- Performance charts with matplotlib
- Side-by-side answer comparison

### Option 3: Run Locally

```bash
git clone https://github.com/anubhavsinghmaar/rag-vs-cag.git
cd rag-vs-cag
# Just open index.html in your browser. No build step needed.
open index.html
```

---

## Tech Stack

| Component | Technology | Cost |
|-----------|-----------|------|
| LLM | Gemini 3 Flash Preview | Free tier |
| Embeddings (Web) | Gemini text-embedding-004 | Free tier |
| Embeddings (Colab) | Sentence Transformers all-MiniLM-L6-v2 | Free |
| Vector Store (Web) | In-memory cosine similarity | Free |
| Vector Store (Colab) | ChromaDB (in-memory) | Free |
| KV Cache (Colab) | Gemini Context Caching API | Free tier |
| Frontend | Vanilla HTML/CSS/JS | Free |
| Hosting | Netlify | Free |
| Notebook | Google Colab T4 GPU | Free |

**Total cost: Rs 0**

---

## Project Structure

```
rag-vs-cag/
├── index.html                    # Live demo (deploy this to Netlify)
├── notebook/
│   └── RAG_vs_CAG_Demo.ipynb     # Google Colab notebook
├── assets/
│   └── screenshot.png            # Demo screenshot (add your own)
└── README.md                     # You are here
```

---

## Data Privacy

- Your Gemini API key is stored **only in browser memory** (not in localStorage, cookies, or any server)
- Your knowledge base text is sent **only to Google's Gemini API** for processing
- No data is sent to any backend, analytics service, or third party
- The entire application runs client-side as a static HTML file
- Nothing persists after you close the tab

---

## Sample Data

The demo comes pre-loaded with a fictional company called **NovaMind Technologies** — a Series B startup building AI copilots for pharma sales reps. This company does not exist. The model has never seen this data in training, which makes it a perfect test case for hallucination detection.

You can replace it with your own data: product docs, internal policies, research notes, or anything you want to test.

---

## Contributing

Found a bug? Want to add a feature? PRs welcome.

Ideas for improvement:
- Add more LLM providers (Claude, GPT) for cross-model comparison
- Implement chunking strategy comparison (fixed vs semantic vs recursive)
- Add cost estimation per query
- Support PDF and DOCX upload
- Add a chart view for history data

---

## Author

**Anubhav Singhmaar**
Product @ Sprinklr | Building AI products

- [LinkedIn](https://linkedin.com/in/anubhavsinghmaar)
- [GitHub](https://github.com/anubhavsinghmaar)

---

## License

MIT — use it however you want.
