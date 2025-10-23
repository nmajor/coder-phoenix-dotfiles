# Ash-Core - Philosophy

**Pages:** 1

---

## Design Principles

**URL:** https://hexdocs.pm/ash/design-principles.html

**Contents:**
- Design Principles
- Anything, not Everything
- Declarative, Introspectable, Derivable
- Configuration over Convention
- Pragmatism First
- Community
  - Domain Driven Design?

The design principles behind Ash allows us to build an extremely flexible and powerful set of tools, without locking users into specific choices at any level. The framework acts as a spinal cord for your application, with extension points at every level to allow for custom behavior. What follows are the core tenets behind Ash Framework.

"Anything, not Everything" means building a framework capable of doing anything, not providing a framework that already does everything. The first is possible, the second is not. Our primary goal is to provide a framework that unlocks potential, and frees developers to work on the things that make their application special.

To this end, there are many prebuilt extensions to use, but there is also a rich suite of tools to build your own extensions. In this way, you can make the framework work for you, instead of struggling to fit your application to a strictly prescribed pattern. Use as much of Ash as you can, and leverage the amazing Elixir ecosystem for everything else.

The real superpower behind Ash is the declarative design pattern. All behavior is driven by explicit, static declarations. A resource, for example, is really just a configuration file. On its own it does nothing. It is provided to code that reads that configuration and acts accordingly.

You can read more about some simple declarative design patterns outside of the context of Ash Framework in An Incremental Approach to Declarative Design.

While convention has value, we believe that explicit configuration ultimately leads to more discoverable, maintainable and flexible applications than a convention driven approach. This means that we never do things like assume that files with a given name are a certain type of thing, or that because a file is in a certain location, it should perform a specific function.

While Ash does have lofty goals and a roadmap, the priority for development is always what the current users of Ash need or are having trouble with. We focus on simple, pragmatic, and integrated solutions that meld well with the rest of the framework.

A high priority is placed on ensuring that our users don't experience feature whip-lash due to poorly thought out implementations, and that any breaking changes (a rare occurrence) have a clean and simple upgrade path. This is something made much easier by the declarative pattern.

The Ash community comes together and collaborates to make sure that we can all build our software quickly, effectively and i

*[Content truncated]*

---
