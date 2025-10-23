---
name: ash-policy-authorizer
description: Authorization and access control. Use for ANY permissions work, role-based access, field-level security, policy rules, actor-based authorization, resource protection, and implementing security rules.
---

# Ash-Policy-Authorizer Skill

Comprehensive assistance with ash-policy-authorizer development, extracted from official documentation and Ash Framework books.

## When to Use This Skill

This skill should be triggered when:
- Implementing authorization or access control in Ash Framework
- Working with policies, policy checks, or policy conditions
- Setting up actor-based permissions
- Defining role-based access control (RBAC)
- Implementing field-level security
- Creating custom policy check modules
- Troubleshooting forbidden errors in Ash actions
- Securing Ash resources, relationships, or aggregates
- Working with `authorize_if`, `forbid_if`, `authorize_unless`, `forbid_unless`
- Using policy bypasses or policy groups
- Implementing multitenancy with policies

## Key Concepts

### What are Policies?

Policies define who has access to resources and what actions they can run. Each resource can have its own set of policies, and each policy can apply to one or more actions.

**Key Points:**
- Policies are checked automatically by Ash before any action runs
- If no matching policy exists, the request is automatically **forbidden**
- Policies apply everywhere: web UI, REST APIs, GraphQL APIs, iex REPL
- Write them once, they're enforced everywhere

### Policy Structure

A policy consists of:
1. **Policy Condition** - Determines if the policy applies (e.g., `action(:publish)`, `action_type(:read)`)
2. **Policy Checks** - One or more checks to authorize or forbid the action

### Policy Check Types

- `authorize_if` - Authorizes if condition is met
- `authorize_unless` - Authorizes if condition is NOT met
- `forbid_if` - Forbids if condition is met
- `forbid_unless` - Forbids if condition is NOT met

### Actors

The **actor** is the entity performing the action (usually a user). In Ash:
- Set via `actor: current_user` option when calling actions
- Can be any record (User, OrganizationMember, etc.)
- Choose the actor type that minimizes database joins for policy checks

### Check Evaluation Order

**IMPORTANT:** Checks are evaluated **top to bottom**. The first check that makes a decision (returns true/false) determines the result. Order matters!

## Quick Reference

### 1. Basic Policy Setup

Enable policies on a resource:

```elixir
defmodule MyApp.Blog.Post do
  use Ash.Resource,
    authorizers: [Ash.Policy.Authorizer]

  policies do
    # Your policies here
  end
end
```

### 2. Simple Allow-All Policy

Allow anyone to read:

```elixir
policies do
  policy action_type(:read) do
    authorize_if always()
  end
end
```

### 3. Actor-Based Policy

Only allow authenticated users to create:

```elixir
policies do
  policy action_type(:create) do
    authorize_if actor_present()
  end
end
```

### 4. Role-Based Access Control

Check actor's role attribute:

```elixir
policies do
  policy action(:publish) do
    forbid_if expr(published == true)
    authorize_if actor_attribute_equals(:role, :admin)
  end
end
```

**Explanation:**
- First checks if post is already published (if so, forbid)
- Then checks if actor has admin role (if so, authorize)
- Order matters! Admins can't override the published check

### 5. Relationship-Based Access

Only allow owners to update their own posts:

```elixir
policies do
  policy action_type(:update) do
    authorize_if relates_to_actor_via(:author)
  end
end
```

### 6. Complex Policy with Multiple Checks

```elixir
policies do
  policy action(:update_project) do
    # Must be related to the project's organization
    forbid_unless relates_to_actor_via([:organization, :organization_members])

    # Owner or admin can always update
    authorize_if actor_attribute_equals(:role, :owner)
    authorize_if actor_attribute_equals(:role, :admin)

    # Members need additional checks
    forbid_unless relates_to_actor_via([:project_members, :organization_member])
    authorize_unless {MyApp.Checks.IsProjectMemberRole, role: :standard}
  end
end
```

### 7. Policy Bypass

Skip further checks if condition is met:

```elixir
policies do
  # Bypass all other checks for owners/admins
  bypass relates_to_actor_via([:organization, :organization_members]) do
    authorize_if actor_attribute_equals(:role, :owner)
    authorize_if actor_attribute_equals(:role, :admin)
  end

  # Other policies only run if bypass didn't authorize
  policy action_type(:read) do
    authorize_if relates_to_actor_via(:project_members)
  end
end
```

### 8. Policy Group (Hierarchical Policies)

Nest policies for better organization:

```elixir
policies do
  policy_group relates_to_actor_via([:organization, :organization_members]) do
    policy action_type(:update) do
      authorize_if actor_attribute_equals(:role, :owner)
      authorize_if actor_attribute_equals(:role, :admin)
    end

    policy action_type(:read) do
      authorize_if always()
    end
  end
end
```

### 9. Custom Policy Check Module

Create reusable custom checks:

```elixir
defmodule MyApp.Checks.CanCreateProject do
  use Ash.Policy.SimpleCheck

  def describe(_) do
    "Checks if actor can create project based on role and org settings"
  end

  # No actor = deny
  def match?(nil, _, _), do: false

  # Pattern match on actor and changeset
  def match?(%{role: actor_role, organization_id: actor_org_id} = _actor,
             %{changeset: changeset}, _opts) do
    project_org_id = Ash.Changeset.get_attribute(changeset, :organization_id)
    org = Ash.get!(MyApp.Organization, actor_org_id)

    allow_project_creation?(actor_role, actor_org_id, project_org_id,
                           org.can_member_create_project)
  end

  defp allow_project_creation?(:owner, org_id, org_id, _), do: true
  defp allow_project_creation?(:admin, org_id, org_id, _), do: true
  defp allow_project_creation?(:member, org_id, org_id, true), do: true
  defp allow_project_creation?(_, _, _, _), do: false
end
```

**Usage:**

```elixir
policies do
  policy action(:create_project) do
    authorize_if MyApp.Checks.CanCreateProject
  end
end
```

### 10. Calling Actions with Actor

Always pass the actor when calling actions:

```elixir
# In Phoenix controller/LiveView
current_user = get_current_user(conn)
MyApp.Blog.create_post(%{title: "Hello"}, actor: current_user)

# Skip authorization (use carefully, mainly for admin/testing)
MyApp.Blog.create_post(%{title: "Hello"}, authorize?: false)
```

## Built-in Policy Checks

### Action-Based Checks
- `action(action_name)` - Check specific action name
- `action_type(:create | :read | :update | :destroy)` - Check action type
- `just_created_with_action(action_name)` - Check if resource was just created

### Actor-Based Checks
- `actor_present()` - Actor must exist
- `actor_absent()` - No actor should exist
- `actor_attribute_equals(attribute, value)` - Check actor attribute

### Relationship Checks
- `relates_to_actor_via(relationship_path)` - Check existing relationship to actor
- `relating_to_actor(relationship)` - Check if changeset creates relationship to actor
- `accessing_from(resource, relationship)` - Check if accessed through relationship
- `changing_relationship(relationship)` - Check if relationship is changing

### Attribute Checks
- `changing_attributes(opts)` - Check if attributes match options
- `selecting(field)` - Check if field is being selected
- `loading(field)` - Check if field is being loaded

### Universal Checks
- `always()` - Always passes
- `never()` - Never passes
- `matches(description, func)` - Custom function check

## Common Patterns

### Allow Unauthenticated Registration

```elixir
policies do
  policy action(:register_user) do
    authorize_if actor_absent()
  end
end
```

### Prevent Double Publishing

```elixir
policies do
  policy action(:publish) do
    forbid_if expr(published == true)
    authorize_if actor_attribute_equals(:role, :editor)
  end
end
```

### Multi-Role Authorization

```elixir
policies do
  policy action_type(:update) do
    authorize_if actor_attribute_equals(:role, :admin)
    authorize_if actor_attribute_equals(:role, :editor)
    authorize_if actor_attribute_equals(:role, :owner)
  end
end
```

### Resource Owner Check

```elixir
policies do
  policy action_type(:destroy) do
    # Only author can delete their own posts
    authorize_if relates_to_actor_via(:author)
  end
end
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

- **book-domain-modeling.md** - Deep dive into policies (Chapter 13, pages 202-223)
  - Policy structure and syntax
  - All built-in policy checks
  - Actor setup and best practices
  - Custom policy check modules
  - Policy groups and bypasses
  - Real-world examples from Tuesday project

- **book-pragmatic-ash.md** - Practical policy implementation (Chapter 6, pages 123-150)
  - Step-by-step policy setup
  - Role-based access control
  - API authentication with policies
  - Testing policies in iex

- **policies.md** - Official hexdocs reference
  - AshPolicyAuthorizer module documentation

Use `view` to read specific reference files when detailed information is needed.

## Working with This Skill

### For Beginners
Start with simple policies:
1. Add `authorizers: [Ash.Policy.Authorizer]` to your resource
2. Create basic policies with `action_type(:read)` + `authorize_if always()`
3. Test in iex with and without `authorize?: false`
4. Gradually add actor-based checks

### For Intermediate Users
- Implement role-based access control with `actor_attribute_equals`
- Use relationship checks like `relates_to_actor_via`
- Understand check evaluation order
- Create policy groups for organization

### For Advanced Users
- Build custom policy check modules
- Implement complex multi-tenant policies
- Use policy bypasses effectively
- Optimize policies to minimize database queries

## Common Troubleshooting

### "Forbidden" Errors
- Check if `authorizers: [Ash.Policy.Authorizer]` is configured
- Ensure at least one policy matches your action
- Verify actor is being passed: `action_name(params, actor: current_user)`
- Test without policies: `action_name(params, authorize?: false)`

### Check Order Issues
- Remember: **First check that decides wins**
- `forbid_if` checks should come before `authorize_if` for exceptions
- Reorder checks if logic seems backwards

### Actor vs. Changeset Relationship Checks
- **`relates_to_actor_via`** - Checks existing record relationships (ignores changes)
- **`relating_to_actor`** - Checks if changeset is creating a relationship to actor

## Resources

- **HexDocs:** https://hexdocs.pm/ash_policy_authorizer
- **Book:** "Ash Framework: Domain Modeling" - Chapter 13: Policies
- **Book:** "Ash Framework: Create Declarative Elixir Web Apps" - Chapter 6: Authorization

## Notes

- This skill was automatically generated from official documentation and books
- Reference files preserve structure and examples from source docs
- Code examples include language detection for proper syntax highlighting
- Quick reference patterns extracted from real-world usage in Tuesday and Tunez projects
