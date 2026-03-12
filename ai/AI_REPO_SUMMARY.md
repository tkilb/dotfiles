# AI Agent Instructions: Repository Analysis & Summary Generation

## Mission

Analyze a given code repository and create a comprehensive summary that helps humans understand the repository's purpose, architecture, connections, and data flows.

## Precheck

Verify with the user which file path you are about to run your analysis against before starting work to save on tokens and computation. The human's IDE may be at a path that is different from their intended target.

## Output Requirements

You MUST create a file named `AI_REPO_SUMMARY.md` in the repository root containing your analysis.

## Analysis Framework

### 1. Repository Overview

Provide a clear, concise description of:

- **Purpose**: What problem does this repository solve? What is its primary function?
- **Technology Stack**: Languages, frameworks, databases, and key dependencies
- **Architecture Pattern**: (e.g., MVC, microservices, serverless, monolith, event-driven)
- **Repository Type**: (e.g., backend API, frontend application, full-stack, library, CLI tool)

### 2. Connection & Endpoint Analysis

This is the CORE focus. Identify and document ALL external connections, endpoints, and integrations.

For EACH connection/endpoint discovered, provide:

#### Required Information:

1. **Connection Type**: Categorize as one of:
   - `HTTP API Endpoint` (REST, GraphQL, etc.)
   - `Database Connection`
   - `External Service Integration` (third-party APIs)
   - `Internal Service Call` (microservice communication)
   - `Message Queue/Event Stream` (Kafka, RabbitMQ, SQS, etc.)
   - `File System/Storage` (S3, local files, etc.)
   - `WebSocket/Real-time Connection`
   - `Authentication/Authorization Service`
   - `Other` (specify)

2. **Connection Name**: Following the naming convention:

   > Use high-level statements with a verb + subject + preposition structure like "Sends e-mail to <SERVICE>" or "Gets customer data from <SERVICE>". Bi-directional connections might be something like "Forms an agreement with <SERVICE>".

   Examples:
   - "Gets user profiles from"
   - "Sends payment data to"
   - "Subscribes to order events from"
   - "Authenticates users with"

3. **Purpose & Reason**:
   - WHY does this connection exist?
   - What data flows through it?
   - Use code comments, variable names, request/response shapes, and context clues
   - Include relevant data properties, parameters, or payload structure

4. **Confidence Level**: Rate your understanding as:
   - `Very High` - Clear documentation, explicit code, obvious purpose
   - `High` - Strong contextual clues, well-named variables/functions
   - `Medium` - Inferred from partial information, reasonable assumptions
   - `Low` - Limited information, significant assumptions required
   - `Very Low` - Unclear purpose, needs human verification

5. **Source References**:
   - File path(s) and line number(s) where connection is defined/used
   - Format: `path/to/file.ext:123-145`
   - Include multiple references if connection is used in multiple places

6. **Direction**:
   - `Outbound` - This repo calls/sends to external system
   - `Inbound` - External systems call/send to this repo
   - `Bi-directional` - Both directions

7. **Additional Details**:
   - Authentication method (if applicable)
   - Rate limits or retry logic (if observed)
   - Error handling approach
   - Any notable patterns or concerns

### 3. Security & Authentication Patterns

Document:

- Authentication mechanisms (JWT, OAuth, API keys, sessions, etc.)
- Authorization patterns (RBAC, permissions, etc.)
- Security-sensitive operations or data handling
- Any security concerns or recommendations

### 4. Data Flow Mapping

Describe the primary data flows:

- How does data enter the system?
- How is data transformed or processed?
- Where does data exit the system?
- Any caching or persistence layers

### 5. Key Files & Directories

List the most important files/directories for understanding the codebase:

- Entry points (main.js, app.py, etc.)
- Configuration files
- Core business logic
- Connection/integration code

## Analysis Process

### Step 1: Initial Exploration

1. Identify the repository structure and technology stack
2. Locate configuration files (package.json, requirements.txt, pom.xml, etc.)
3. Find entry points and routing definitions
4. Review README, documentation, and code comments

### Step 2: Connection Discovery

Search for patterns indicating connections:

- HTTP client libraries (axios, fetch, requests, HttpClient, etc.)
- Database clients (mongoose, sequelize, psycopg2, JDBC, etc.)
- SDK imports (AWS SDK, Stripe, SendGrid, etc.)
- WebSocket libraries
- Message queue clients
- Environment variables for endpoints/URLs
- Configuration files with service URLs
- API route definitions
- GraphQL schemas

### Step 3: Deep Analysis

For each connection found:

1. Trace the code flow to understand purpose
2. Examine request/response structures
3. Read surrounding code comments
4. Review variable/function names for context
5. Check for error handling or logging that explains behavior
6. Assess your confidence level

### Step 4: Synthesis

1. Organize findings into logical groups
2. Identify patterns and architecture
3. Note any gaps or uncertainties
4. Formulate recommendations if needed

## Output Format: AI_REPO_SUMMARY.md

```markdown
# Repository Summary: [Repository Name]

**Generated**: [Date]  
**Analyzed By**: AI Agent

---

## 1. Overview

**Purpose**: [Clear description of what this repo does]

**Technology Stack**:

- Languages: [list]
- Frameworks: [list]
- Databases: [list]
- Key Dependencies: [list]

**Architecture Pattern**: [pattern name and brief explanation]

**Repository Type**: [type]

---

## 2. Connections & Endpoints

### Summary

- Total Connections Identified: [number]
- Breakdown by Type:
  - HTTP API Endpoints: [count]
  - Database Connections: [count]
  - External Services: [count]
  - [etc.]

### Detailed Connection Inventory

#### Connection #1: [Connection Name]

**Type**: [Connection Type]

**Name**: [Verb + Subject + Preposition format]

**Direction**: [Inbound/Outbound/Bi-directional]

**Purpose**:
[Detailed explanation of why this connection exists and what it does]

**Data Details**:

- Request/Input: [structure/properties]
- Response/Output: [structure/properties]
- Key Data Fields: [relevant fields]

**Confidence Level**: [Very High/High/Medium/Low/Very Low]

**Reasoning**: [Why this confidence level?]

**Source References**:

- `path/to/file.ext:line-range`
- `another/file.ext:line-range`

**Additional Details**:

- Authentication: [method]
- Error Handling: [approach]
- Notable Patterns: [any observations]

---

[Repeat for each connection]

---

## 3. Security & Authentication

**Authentication Mechanisms**:

- [List mechanisms found]

**Authorization Patterns**:

- [List patterns found]

**Security Considerations**:

- [Any concerns or recommendations]

---

## 4. Data Flow

**Data Ingestion**:

- [How data enters the system]

**Data Processing**:

- [How data is transformed/processed]

**Data Output**:

- [How data exits the system]

**Persistence & Caching**:

- [Storage mechanisms]

---

## 5. Key Files & Directories

| Path                 | Purpose       |
| -------------------- | ------------- |
| `path/to/file`       | [Description] |
| `path/to/directory/` | [Description] |

---

## 6. Analysis Notes

**Gaps & Uncertainties**:

- [List any areas where confidence is low or information is missing]

**Recommendations**:

- [Suggestions for improving clarity, documentation, or architecture]

**Next Steps for Human Review**:

- [Specific areas that need human verification]

---

## Appendix: Connection Summary Table

| #   | Name   | Type   | Direction   | Confidence | File Reference |
| --- | ------ | ------ | ----------- | ---------- | -------------- |
| 1   | [Name] | [Type] | [Direction] | [Level]    | `file:line`    |
| 2   | [Name] | [Type] | [Direction] | [Level]    | `file:line`    |

[...]

---

_This summary was generated by an AI agent. Please review and verify the findings, especially items marked with Low or Very Low confidence._
```

## Important Guidelines

### Be Thorough

- Scan the entire codebase, not just main files
- Check configuration files, environment variables, and infrastructure code
- Look in tests for additional context
- Review comments and documentation

### Be Honest About Confidence

- Don't guess if you're uncertain
- Clearly mark assumptions
- Explain reasoning for confidence levels
- Flag areas needing human review

### Be Helpful

- Use clear, non-technical language when possible
- Provide context that helps humans understand
- Suggest meaningful connection names
- Include enough detail to be actionable

### Be Accurate

- Verify findings by cross-referencing multiple sources
- Don't hallucinate connections
- If code is ambiguous, say so
- Cite specific line numbers for verification

## Edge Cases & Special Considerations

1. **Monorepos**: Analyze each package/module separately if appropriate
2. **Deprecated Code**: Note if connections appear unused or deprecated
3. **Development vs Production**: Distinguish between dev/test/prod configurations
4. **Dynamic Endpoints**: Handle cases where URLs are constructed dynamically
5. **Abstraction Layers**: Trace through wrappers and abstractions to find actual connections
6. **Conditional Logic**: Note when connections are conditional (feature flags, env-based, etc.)

## Quality Checklist

Before finalizing REPO_SUMMARY.md, verify:

- [ ] All connection types are categorized correctly
- [ ] Each connection has a descriptive name following the convention
- [ ] Confidence levels are honest and justified
- [ ] File references are accurate and specific
- [ ] Purpose explanations include relevant data/property details
- [ ] Security and authentication patterns are documented
- [ ] Data flow is clearly described
- [ ] Gaps and uncertainties are explicitly noted
- [ ] Summary is well-organized and easy to navigate
- [ ] Markdown formatting is correct

## Final Note

Your goal is to make the repository comprehensible to someone who has never seen it before. Focus on answering: "What does this code connect to, and why?" Be thorough, honest, and helpful.
