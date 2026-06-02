# Video Demo Script: Jenkins vs Harness Database DevOps

## 🎬 Video Overview

**Title:** "Database Governance: Jenkins Complexity vs Harness Simplicity"
**Target Length:** 20-25 minutes
**Target Audience:** DevOps engineers, DBAs, Engineering Managers, CTOs

**Goal:** Show the stark contrast between implementing database governance in traditional CI/CD (Jenkins) versus using Harness Database DevOps platform.

---

## 📋 Video Structure

### Act 1: The Problem (3 minutes)
### Act 2: Jenkins Approach - The Complexity (8 minutes)
### Act 3: Harness Approach - The Solution (8 minutes)
### Act 4: Side-by-Side Comparison (4 minutes)
### Act 5: Conclusion & Call to Action (2 minutes)

---

## 🎭 ACT 1: The Problem (3 minutes)

### Opening Shot
**Visual:** Split screen - messy code on left, clean UI on right

**Voiceover:**
> "Database governance is critical for modern applications. You need table naming standards, index validation, rollback capabilities, and approval workflows. But there's a problem..."

### The Challenge

**Screen:** Show a typical database migration scenario

**Narrator:**
> "Traditional CI/CD tools like Jenkins require extensive custom scripting to implement these governance policies. Let me show you just how complex this gets..."

**Screen:** Quick flash of:
- 450-line Jenkinsfile
- Python validation scripts
- Configuration files
- Installation scripts

**Narrator:**
> "That's over **1,400 lines of code** you need to write, test, and maintain. Today, I'm going to show you a side-by-side comparison of implementing the **same database pipeline** in Jenkins versus Harness Database DevOps."

**Key Point on Screen:**
```
The Same Pipeline:
• Jenkins: 1,400+ lines of code
• Harness: ~50 lines of config
```

---

## 🎭 ACT 2: Jenkins Approach - The Complexity (8 minutes)

### Setup Phase (2 minutes)

**Screen:** Show Jenkins UI

**Narrator:**
> "Let's start with Jenkins. First, we need to set up our pipeline..."

**Screen:** Open `Jenkinsfile.liquibase` in editor

**Narrator (scrolling through file):**
> "Here's our Jenkinsfile - **450 lines of Groovy code**. Let me walk you through the key sections..."

**Zoom in on Setup Stage (Lines 71-95):**

```groovy
sh '''
    if [ ! -d "${LIQUIBASE_HOME}" ]; then
        echo "📦 Installing Liquibase ${LIQUIBASE_VERSION}..."
        wget -q https://github.com/liquibase/liquibase/releases/download/...
        tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz
        ...
    fi
'''
```

**Narrator:**
> "Stage one: Installation. We need to download Liquibase, extract it, install JDBC drivers... This is all **custom shell scripting** that we have to maintain. Every time Liquibase updates, we need to update these scripts."

### Governance Phase (3 minutes)

**Screen:** Scroll to Governance Checks (Lines 120-290)

**Narrator:**
> "Now comes the governance policies. Here's where it gets really complex..."

**Zoom in on Table Naming Validation:**

```python
def validate_table_name(table_name):
    errors = []
    if not re.match(r'^[a-z][a-z0-9_]*$', table_name):
        errors.append(f"Table '{table_name}' is not in snake_case")
    if re.match(r'^(tbl|tb|table)_', table_name):
        errors.append(f"Table '{table_name}' uses prohibited prefix")
    # ... more validation
```

**Narrator:**
> "For **every governance policy**, we need to write a **custom Python script**. This is table naming validation - **60 lines of code**."

**Screen:** Quick scroll through other policies

**Narrator:**
> "Index validation? **70 more lines**. Column naming? **60 lines**. Rollback validation? **40 lines**. SQL quality checks? **80 lines**."

**Overlay on screen:**
```
Custom Governance Scripts:
✓ Table naming:    60 lines Python
✓ Index validation: 70 lines Python
✓ Column naming:   60 lines Python
✓ Rollback check:  40 lines Python
✓ SQL quality:     80 lines Python
─────────────────────────────────
Total:            310 lines Python
```

**Narrator:**
> "That's **over 300 lines of Python** you need to write, test, debug, and maintain. Want to add a new policy? Plan on spending **2-4 hours** writing another script."

### Execution Phase (2 minutes)

**Screen:** Show actual Jenkins job running

**Narrator:**
> "Let's run this pipeline..."

**Screen:** Show Jenkins console output scrolling

```
[Pipeline] sh
+ /workspace/liquibase/liquibase --changelog-file=liquibase/gcp.yaml update
Liquibase Version: 4.24.0
Running Changeset: liquibase/gcp.yaml::001-create-users::platform-team
...
```

**Narrator:**
> "Notice the console output - it's all text-based logs. If something fails, you're digging through **hundreds of lines of text** to find the issue."

**Screen:** Show migration status artifacts

**Narrator:**
> "Want to see the migration preview? You need to download this artifact and open it locally. There's no visual representation."

### Problems Summary (1 minute)

**Screen:** Bullet list animation

**Narrator:**
> "Let's recap the problems with the Jenkins approach:"

**On-screen list:**
```
Jenkins Problems:
❌ 450+ lines of Groovy pipeline code
❌ 300+ lines of custom Python scripts
❌ Manual installation and setup
❌ Text-only logs (hard to debug)
❌ No visual preview
❌ No automatic rollback
❌ 40-66 hours/month maintenance
❌ Steep learning curve (7-10 weeks)
```

**Narrator:**
> "And remember - this is just for **one** database type. If you need to support MySQL, Oracle, and PostgreSQL? Multiply all of this by three."

---

## 🎭 ACT 3: Harness Approach - The Solution (8 minutes)

### Introduction (1 minute)

**Screen:** Harness Database DevOps dashboard

**Narrator:**
> "Now let's see the same pipeline in Harness Database DevOps. I'll warn you - it's almost disappointingly simple."

### Setup Phase (2 minutes)

**Screen:** Harness UI - Pipeline Studio

**Narrator:**
> "First, let's create our pipeline. No code required - this is a **visual pipeline builder**."

**Screen:** Drag-and-drop demo
1. Drag "DatabaseDevOps" stage onto canvas
2. Click to configure

**Narrator:**
> "I'm just dragging and dropping stages. No Groovy, no bash, no Python. Just configuration."

**Screen:** Configure database connection

**Narrator:**
> "For the database connection, I select a pre-configured connector. No need to download JDBC drivers or manage connection strings - Harness handles all of that."

**Configuration shown:**
```yaml
stage:
  name: Deploy Schema
  type: DatabaseDevOps
  spec:
    connectorRef: production_db
    changelogPath: liquibase/gcp.yaml
    context: cloudsql-pg
```

**Narrator:**
> "That's it. **Five lines of configuration**. Compare that to our **450-line Jenkinsfile**."

### Governance Phase (3 minutes)

**Screen:** Navigate to Policy Management

**Narrator:**
> "Now for governance policies - remember those **300 lines of Python** we wrote in Jenkins? Watch this..."

**Screen:** Click "Create Policy" → "Database Standards"

**Narrator:**
> "I'm opening the policy builder. There's a **template library** with pre-built policies."

**Screen:** Policy configuration UI

**Select from checkboxes:**
- ☑️ Table naming standards
- ☑️ Index requirements
- ☑️ Column naming standards
- ☑️ Rollback validation
- ☑️ SQL quality checks

**Narrator:**
> "I'm just **clicking checkboxes**. Each policy is already implemented and tested by Harness. No custom scripts, no Python, no maintenance burden."

**Screen:** Configure table naming rules via form

```
Policy: Table Naming Standards
├─ Pattern: ^[a-z][a-z0-9_]*$
├─ Severity: ERROR
├─ Message: "Tables must use snake_case"
└─ Environments: [production, staging]
```

**Narrator:**
> "For each policy, I configure the rules through a **form-based UI**. No regular expressions to debug, no YAML parsing errors, no script bugs."

**Time comparison overlay:**
```
Add New Governance Policy:
Jenkins:  2-4 hours (coding + testing)
Harness:  5-10 minutes (UI configuration)
```

### Execution Phase (2 minutes)

**Screen:** Click "Run Pipeline"

**Narrator:**
> "Let's run this pipeline and watch what happens..."

**Screen:** Real-time visual progress

**Narrator:**
> "Notice we get **real-time visual progress**. I can see exactly which changeset is running, how long it's taking, and what's happening."

**Screen:** Show visual schema diff

**Narrator:**
> "Here's the migration preview - a **visual schema diff**. I can see before-and-after states side by side. This is so much better than that text SQL dump we had to download in Jenkins."

**Screen:** Show approval notification

**Narrator:**
> "For production, there's an approval gate. The DBA gets a **Slack notification** with a direct link to review and approve. In Jenkins, we had to poll for the 'input' step."

**Screen:** Click "Approve"

**Narrator:**
> "One click to approve, and the migration executes."

**Screen:** Show completed execution with metrics

**Narrator:**
> "And we're done. Notice the **structured dashboard** - execution time, changesets applied, health checks passed. All in a visual format that's easy to understand."

### Rollback Demo (1 minute)

**Screen:** Click "Rollback" button

**Narrator:**
> "Now here's the real kicker - what if something goes wrong? In Jenkins, we'd need to run a separate job with custom rollback scripts. In Harness?"

**Screen:** Rollback confirmation dialog

**Narrator:**
> "**One click**. Harness automatically executes the rollback scripts defined in our Liquibase changelog."

**Screen:** Rollback executing

**Timer overlay:**
```
Rollback Time:
Jenkins:  15-30 minutes (manual intervention)
Harness:  30 seconds (one-click)
```

**Narrator:**
> "30 seconds. That's it. This alone could save you from hours of downtime."

---

## 🎭 ACT 4: Side-by-Side Comparison (4 minutes)

### Split Screen Comparison (2 minutes)

**Screen:** Split screen - Jenkins left, Harness right

**Narrator:**
> "Let's see them side by side..."

**Comparison 1: Code Complexity**

**Left (Jenkins):** Scroll through 450-line Jenkinsfile
**Right (Harness):** Show 50-line YAML

**Overlay:**
```
Lines of Code:
Jenkins:  1,400+
Harness:  ~50
Reduction: 96%
```

**Comparison 2: Governance Setup**

**Left (Jenkins):** Show Python script with 300+ lines
**Right (Harness):** Show policy UI with checkboxes

**Overlay:**
```
Add New Policy:
Jenkins:  2-4 hours (coding)
Harness:  5-10 minutes (UI)
Reduction: 95%
```

**Comparison 3: Execution**

**Left (Jenkins):** Text-based console logs
**Right (Harness):** Visual dashboard

**Comparison 4: Rollback**

**Left (Jenkins):** Show manual rollback job
**Right (Harness):** Show one-click rollback button

### Metrics Dashboard (2 minutes)

**Screen:** Animated metrics table

**Narrator:**
> "Let's talk numbers..."

**Show comparison table:**

```
╔══════════════════════════╦═══════════╦═══════════╦═══════════╗
║ Metric                   ║ Jenkins   ║ Harness   ║ Reduction ║
╠══════════════════════════╬═══════════╬═══════════╬═══════════╣
║ Setup Time               ║ 2-3 days  ║ 2-4 hours ║ 90%       ║
║ Lines of Code            ║ 1,400+    ║ ~50       ║ 96%       ║
║ Maintenance (hrs/month)  ║ 40-66     ║ 3-8       ║ 85%       ║
║ Learning Curve           ║ 7-10 wks  ║ 1-2 wks   ║ 80%       ║
║ Annual TCO               ║ $90-120K  ║ $15-35K   ║ 70%       ║
╚══════════════════════════╩═══════════╩═══════════╩═══════════╝
```

**Narrator:**
> "Harness reduces setup time by **90%**, code complexity by **96%**, and total cost by **70%**."

**Screen:** ROI calculation

```
Annual Value:
Engineering Savings:     $75,000
Risk Reduction:         $300,000
Faster Time-to-Market:   $50,000
────────────────────────────────
TOTAL ANNUAL VALUE:     $425,000

ROI: 1,500% (15x return)
Payback Period: < 1 month
```

**Narrator:**
> "That's a **15x return on investment** with a payback period of **less than one month**."

---

## 🎭 ACT 5: Conclusion & Call to Action (2 minutes)

### When to Use Each (30 seconds)

**Screen:** Decision matrix

**Narrator:**
> "So when should you use each approach?"

**Show table:**

```
Use Jenkins When:
✓ Very small team (1-2 developers)
✓ Simple databases (single table)
✓ No governance requirements
✓ Learning/educational purposes

Use Harness Database DevOps When:
✓ Production enterprise applications
✓ Teams of any size
✓ Multi-environment deployments
✓ Governance & compliance required
✓ Fast-moving development teams
✓ You value developer productivity
```

**Narrator:**
> "For production use cases, the choice is clear."

### Key Takeaways (1 minute)

**Screen:** Animated bullet points

**Narrator:**
> "Here are your key takeaways:"

```
✅ Jenkins requires 1,400+ lines of custom code
   Harness needs ~50 lines of configuration

✅ Jenkins needs 300+ lines of Python for governance
   Harness provides UI-based policy management

✅ Jenkins maintenance: 40-66 hours/month
   Harness maintenance: 3-8 hours/month

✅ Jenkins TCO: $90-120K/year
   Harness TCO: $15-35K/year (70% savings)

✅ Jenkins rollback: 15-30 minutes manual
   Harness rollback: 30 seconds one-click

✅ Jenkins learning curve: 7-10 weeks
   Harness learning curve: 1-2 weeks
```

### Final Message (30 seconds)

**Screen:** Harness logo and call-to-action

**Narrator:**
> "Stop fighting complexity. Stop writing custom scripts. Stop spending weeks on what should take hours."

**Screen:** Show signup form

**Narrator:**
> "Start your free trial of Harness Database DevOps today. Get **hours to production** instead of weeks. Get **70% lower TCO**. Get **peace of mind** with built-in governance and one-click rollback."

**On-screen text:**
```
🚀 Try Harness Database DevOps Free
   https://app.harness.io/auth/#/signup

📚 Documentation & Training
   https://developer.harness.io/docs/database-devops/
   https://university.harness.io/

💬 Questions? Contact Us
   sales@harness.io
```

**Narrator:**
> "The link is in the description. Thank you for watching!"

**Screen:** End card with:
- Harness logo
- Social media links
- "Subscribe for more DevOps tips"

---

## 🎥 Production Notes

### Camera Work

**Primary Shots:**
1. **Screen recordings** (85% of video)
   - Jenkins UI / code
   - Harness UI
   - Side-by-side comparisons

2. **Talking head** (15% of video)
   - Introduction
   - Key transitions
   - Conclusion

### Screen Recording Checklist

**Before Recording:**
- [ ] Clean browser cache
- [ ] Close unnecessary tabs
- [ ] Set zoom level to 125% for readability
- [ ] Hide personal information
- [ ] Prepare demo databases with sample data
- [ ] Test Jenkins job runs successfully
- [ ] Test Harness pipeline runs successfully
- [ ] Prepare "failure" scenarios for rollback demo

**Recording Settings:**
- Resolution: 1920x1080 (1080p)
- Frame rate: 60fps
- Bitrate: High quality
- Cursor: Highlight enabled
- Audio: Lossless quality

### Editing Checklist

**Visual Elements:**
- [ ] Add animated text overlays for key metrics
- [ ] Add zoom effects on important code sections
- [ ] Add comparison graphics (split screen)
- [ ] Add progress indicators ("Part 1 of 5")
- [ ] Color code: Jenkins (gray/neutral), Harness (blue/branded)

**Audio:**
- [ ] Remove "um", "uh", long pauses
- [ ] Normalize audio levels
- [ ] Add subtle background music (low volume)
- [ ] Add sound effects for transitions

**Graphics:**
- [ ] Intro animation (5 seconds)
- [ ] Lower thirds with speaker name/title
- [ ] Animated comparison tables
- [ ] End card with CTAs

### B-Roll Suggestions

- Developers looking frustrated at code
- Clean, organized dashboard
- Team collaboration
- Before/after visualizations
- Success metrics graphs

---

## 📝 Script Variations

### Short Version (10 minutes)

For social media / quick demo:
- Skip detailed Jenkins walkthrough
- Focus on side-by-side comparison
- Emphasize metrics (96% less code, 70% lower cost)
- Quick rollback demo

### Long Version (45 minutes)

For webinars / deep dives:
- Live coding of Jenkins governance scripts
- Step-by-step Harness setup
- Multiple governance policy examples
- Q&A section
- Advanced features (multi-environment, RBAC)

### Executive Version (5 minutes)

For C-level audience:
- Skip technical details
- Focus on TCO and ROI
- Emphasize risk reduction
- Business impact stories

---

## 🎯 Success Metrics

Track these metrics after video publication:

**Engagement:**
- Views
- Watch time (aim for >60% retention)
- Likes/comments
- Shares

**Business Impact:**
- Free trial signups attributed to video
- Demo requests
- Sales pipeline influenced

**Feedback:**
- Comments sentiment
- Questions asked (for FAQ)
- Feature requests

---

## 📞 Support Materials

Provide in video description:

1. **GitHub Repository**
   - Link to this repo with all Jenkins files
   - README with setup instructions

2. **Comparison Documents**
   - JENKINS_VS_HARNESS_COMPARISON.md
   - QUICK_COMPARISON_TABLE.md

3. **Resources**
   - Harness free trial link
   - Documentation links
   - University training links
   - Blog posts

4. **Contact**
   - Sales contact form
   - Community Slack
   - Support email

---

**Document Version:** 1.0
**Last Updated:** 2026-06-01
**For:** Video Production Team
**Estimated Production Time:** 2-3 days
**Target Release:** Q2 2026
