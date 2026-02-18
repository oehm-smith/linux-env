# Technical Solution Plan: DMUnify SMSF Workflow Management

## Problem Statement

Dipak manages ~40 SMSF clients with a complex multi-party workflow (Client → Dipak → Auditor → JPA Tax). Currently tracks everything on paper, leading to:
- High anxiety about missing deadlines/documents
- No visibility into workflow stage per client
- Lost documents across email/WhatsApp/OneDrive
- Manual reminder burden

## Goals (Phased)

### Phase 1: Visibility
- Single view of all SMSF clients and their workflow stage
- Document checklist per client (requested vs received)
- Correspondence log

### Phase 2: Notifications
- Alert when documents uploaded to OneDrive
- Daily task/reminder list

### Phase 3: Automation (Future)
- Automated reminder emails
- Workflow state changes based on triggers

---

## Technical Approaches Under Consideration

### Option A: Microsoft Power Platform (Native 365)
**Pros:**
- Stays entirely within Office 365 ecosystem
- Power Automate can trigger on OneDrive/SharePoint/Outlook events natively
- Power Apps provides simple UI building
- SharePoint Lists for workflow state storage
- No external hosting costs
- Dipak already has 365 admin access

**Cons:**
- Learning curve for Power Platform
- Less flexible than custom code
- Power Automate premium connectors may have costs

### Option B: Custom Dashboard + Microsoft Graph API
**Pros:**
- Full flexibility
- Can build exactly what's needed
- Read-only API access (safe)

**Cons:**
- Requires hosting (Vercel, Azure, etc.)
- More development time
- Ongoing maintenance

### Option C: Existing Workflow Tool (Notion/Monday/Asana) + Zapier
**Pros:**
- Quick to set up
- Proven workflow tools
- Zapier handles integrations

**Cons:**
- Another subscription ($20-50/month)
- Data lives outside 365 ecosystem
- May not integrate deeply with Outlook/SharePoint

### Option D: Simple SharePoint-Based Solution
**Pros:**
- Zero additional cost
- Uses existing SharePoint skills
- SharePoint Lists can serve as simple database
- Power Automate (included in 365) for basic notifications

**Cons:**
- UI limited to SharePoint capabilities
- Less elegant than custom solution

---

## Questions to Clarify

1. **Platform preference**: Build in 365 ecosystem (Power Platform/SharePoint) or external tool?
2. **Hosting**: Is Dipak okay with a small hosting cost, or must it be zero-cost?
3. **First deliverable**: Which capability provides most value first?
   - Workflow status dashboard?
   - Document checklist?
   - Email archiving to OneDrive?
   - OneDrive upload notifications?
4. **Your involvement**: One-time build, or ongoing support relationship?
5. **Technology you prefer**: Are you comfortable with Power Platform, or prefer coding a custom solution?

---

## Recommended Approach (Pending Clarification)

**TBD after discussion with Brooke**

---

## Implementation Phases

### Phase 1: Foundation (TBD)
- [ ] Decide on platform
- [ ] Set up development/test environment
- [ ] Implement core workflow tracking

### Phase 2: Integration (TBD)
- [ ] Connect to Outlook/OneDrive
- [ ] Implement document tracking
- [ ] Set up notifications

### Phase 3: Refinement (TBD)
- [ ] User testing with Dipak
- [ ] Iterate based on feedback
- [ ] Document for handoff

---

## Cost Considerations

| Component | Estimated Cost |
|-----------|----------------|
| Power Platform | Included in 365 Business |
| Custom hosting (Vercel/Azure) | $0-20/month |
| Zapier (if used) | $20-50/month |
| Development time | Negotiable |
