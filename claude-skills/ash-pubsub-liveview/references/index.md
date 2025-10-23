# Ash PubSub + LiveView Reference Index

Comprehensive reference documentation for real-time features with Ash Framework and Phoenix LiveView.

## Getting Started

**New to Ash PubSub?** Follow this sequence:

1. **[Ash Resource Setup](ash-resource-setup.md)** - Configure your Ash resources for PubSub
   - Basic pub_sub configuration
   - Topic patterns (static, dynamic, multi-tenant)
   - Event name customization
   - Real-world examples

2. **[Event Names & Topics](event-names-topics.md)** - Understand how events work
   - Automatic event name generation
   - Topic naming best practices
   - Pattern matching in LiveView
   - Debugging topic mismatches

3. **Main SKILL.md** - Implement LiveView patterns
   - Tier 1: Simple & Reliable (start here)
   - Tier 2: Optimized for Scale
   - Common patterns and use cases

4. **[Edge Cases & Pitfalls](edge-cases-pitfalls.md)** - Avoid common mistakes
   - What `keep_live` handles automatically
   - Common pitfalls and how to avoid them
   - Specific edge case solutions
   - Testing strategies

## Quick Navigation

### By Topic

**Setup & Configuration:**
- [Ash Resource Setup](ash-resource-setup.md#basic-configuration)
- [PubSub Module Configuration](ash-resource-setup.md#pub-sub-module)
- [Multi-Tenancy Setup](ash-resource-setup.md#multi-tenancy)

**LiveView Implementation:**
- [Tier 1 Pattern](../SKILL.md#tier-1-simple--reliable-start-here)
- [Tier 2 Pattern](../SKILL.md#tier-2-optimized-for-scale)
- [Multiple Queries](../SKILL.md#pattern-multiple-queries)
- [LiveComponents](../SKILL.md#pattern-with-livecomponents)

**Topics & Events:**
- [Topic Patterns](event-names-topics.md#topic-patterns)
- [Event Name Generation](event-names-topics.md#event-name-generation)
- [Prefix Configuration](event-names-topics.md#prefix-configuration)
- [Topic Debugging](event-names-topics.md#debugging-topics)

**Troubleshooting:**
- [Common Pitfalls](edge-cases-pitfalls.md#common-pitfalls)
- [Edge Cases](edge-cases-pitfalls.md#specific-edge-cases)
- [Debugging Checklist](edge-cases-pitfalls.md#debugging-checklist)
- [Testing Examples](edge-cases-pitfalls.md#testing-for-edge-cases)

### By Use Case

**Building a List View:**
1. [Configure resource](ash-resource-setup.md#basic-configuration) with `publish :create/:update/:destroy`
2. [Subscribe to topic](event-names-topics.md#static-topics) in LiveView
3. [Implement Tier 1 pattern](../SKILL.md#tier-1-simple--reliable-start-here)
4. [Optimize to Tier 2](../SKILL.md#tier-2-optimized-for-scale) if needed

**Building a Show Page:**
1. [Use dynamic topic](event-names-topics.md#dynamic-topics-with-ids) with record ID
2. [Subscribe to single record](../SKILL.md#pattern-single-record-show-page)
3. Handle updates with `handle_live`

**User-Scoped Views:**
1. [Configure user-scoped topics](ash-resource-setup.md#update-specific-old-and-new-values)
2. [Subscribe with user ID](event-names-topics.md#user-scoped-topics)
3. [Filter query by user](../SKILL.md#pattern-filtered-list)

**Background Job Progress:**
1. Configure Oban worker to update Ash resource
2. Ash broadcasts updates automatically
3. LiveView uses Tier 2 pattern for smooth updates
4. [Debounce rapid updates](edge-cases-pitfalls.md#edge-case-3-rapid-successive-updates)

**Multi-Tenant Applications:**
1. [Configure multi-tenancy](ash-resource-setup.md#multi-tenancy)
2. [Use `:_tenant` in topics](event-names-topics.md#special-topic-atoms)
3. Subscribe with tenant context
4. [Handle tenant switching](edge-cases-pitfalls.md#edge-case-4-multi-tenant-data-leakage)

## Implementation Checklist

### Resource Configuration

- [ ] Add `pub_sub` block to resource
- [ ] Configure `module` (PubSub module name)
- [ ] Add `publish` declarations for actions
- [ ] Choose appropriate topic patterns
- [ ] Test with debug mode enabled

### LiveView Implementation

- [ ] Import `AshPhoenix.LiveView`
- [ ] Use `keep_live/4` in mount
- [ ] Always pass `actor:` option in Ash queries
- [ ] Implement `handle_info/2` with `handle_live/3`
- [ ] Pattern match on `%Ash.Notifier.Notification{}`

### Testing

- [ ] Test with multiple users/sessions
- [ ] Verify authorization (data visibility)
- [ ] Test network reconnection
- [ ] Verify topic subscriptions
- [ ] Check for race conditions

### Optimization (if needed)

- [ ] Measure performance (list size, update frequency)
- [ ] Implement Tier 2 granular updates
- [ ] Use streams for large lists
- [ ] Consider debouncing rapid updates
- [ ] Monitor with LiveDashboard

## Reference Files

- **[ash-resource-setup.md](ash-resource-setup.md)** - Complete Ash resource configuration guide
- **[event-names-topics.md](event-names-topics.md)** - Event and topic pattern reference
- **[edge-cases-pitfalls.md](edge-cases-pitfalls.md)** - Common mistakes and solutions

## External Resources

- **Ash.Notifier.PubSub**: https://hexdocs.pm/ash/Ash.Notifier.PubSub.html
- **AshPhoenix.LiveView**: https://hexdocs.pm/ash_phoenix/AshPhoenix.LiveView.html
- **Phoenix.LiveView**: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html
- **Phoenix.PubSub**: https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html

## Next Steps

1. **Start simple** - Use Tier 1 pattern for all new features
2. **Measure** - Profile with LiveDashboard before optimizing
3. **Optimize** - Evolve to Tier 2 only when needed
4. **Test** - Verify with multiple users and edge cases
