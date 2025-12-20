# Domain-Driven Design (DDD)

## Skill Identity
- **Name**: Domain-Driven Design
- **Category**: Methodology (Crosscutting)
- **SWECOM Alignment**: Influences all Life Cycle and Crosscutting skill areas
- **Primary Source**: Eric Evans - Domain-Driven Design (2003)

## Purpose
Apply Domain-Driven Design principles and patterns to build software that accurately models complex business domains. DDD provides both strategic patterns (for organizing large systems) and tactical patterns (for implementing rich domain models).

## When to Apply This Skill

### Use DDD When:
- **High domain complexity**: Intricate business rules and processes
- **Long-term evolution**: System will evolve with business over years
- **Competitive advantage**: Domain knowledge is key differentiator
- **Close domain expert collaboration**: Regular access to business experts
- **Complex business rules**: Logic that goes beyond simple CRUD

### Skip or Minimize DDD When:
- Simple data entry or CRUD applications
- Technical/infrastructure-focused projects
- Well-understood technical problems with existing solutions
- Short-lived prototypes or proof-of-concepts
- Generic subdomains (use off-the-shelf solutions)

## Core Principles

### 1. Ubiquitous Language
**Definition**: A shared language between developers and domain experts that is used in code, conversations, and documentation.

**In Practice**:
- Class names, method names, variables use business terminology
- If domain expert says "Policy Effective Date", code uses `policyEffectiveDate` not `startDate`
- Team discussions and code reviews use the same terms
- Documents, diagrams, and tests use ubiquitous language

**Example**:
```java
// Poor - technical language
class Record {
    Date start;
    void activate() { ... }
}

// Good - ubiquitous language
class InsurancePolicy {
    EffectiveDate effectiveDate;
    void underwrite() { ... }
}
```

### 2. Bounded Contexts
**Definition**: Explicit boundaries within which a particular domain model applies. Each context has its own ubiquitous language and model.

**In Practice**:
- Large systems have multiple bounded contexts
- The same term can mean different things in different contexts
- Define explicit relationships between contexts (Context Map)
- Each context can have its own architecture, database, team

**Example Contexts**:
- E-commerce: Shopping Cart Context, Order Fulfillment Context, Inventory Context
- Insurance: Underwriting Context, Claims Context, Billing Context

### 3. Core Domain
**Definition**: The part of the domain that provides the most value and competitive advantage. This is where to focus DDD efforts.

**In Practice**:
- Identify what makes your business unique
- Invest heavily in modeling the core domain
- Generic subdomains (auth, email) can use off-the-shelf solutions
- Supporting subdomains get lighter DDD treatment

## Strategic Design Patterns

### Context Mapping
Define how bounded contexts relate to each other:

- **Partnership**: Two contexts succeed or fail together
- **Shared Kernel**: Small shared model between contexts
- **Customer/Supplier**: Downstream context depends on upstream
- **Conformist**: Downstream conforms to upstream model
- **Anti-Corruption Layer**: Protect your context from external model
- **Open Host Service**: Define protocol for others to use
- **Published Language**: Well-documented shared language

### Distillation
Focus efforts on the Core Domain:
- **Core Domain**: The most valuable subdomain
- **Generic Subdomain**: Necessary but not special (auth, logging)
- **Supporting Subdomain**: Supports core but isn't differentiating

## Tactical Design Patterns (Building Blocks)

### Entity
**Definition**: An object defined by its identity, not its attributes. Identity persists through changes.

**Characteristics**:
- Has unique identifier (ID)
- Can change attributes while remaining the same entity
- Lifecycle tracked over time
- Equality based on ID, not attributes

**Examples**: Customer, Order, Invoice, BankAccount
```java
class Customer {
    private CustomerId id;  // Identity
    private String name;    // Can change
    private Email email;    // Can change
    
    // Equality based on ID
    public boolean equals(Object o) {
        return this.id.equals(((Customer)o).id);
    }
}
```

### Value Object
**Definition**: An object defined by its attributes, not identity. Immutable and interchangeable.

**Characteristics**:
- No unique identifier
- Immutable (create new instead of modifying)
- Equality based on attributes
- Can be shared safely

**Examples**: Money, Address, DateRange, Coordinate, Color
```java
class Money {
    private final BigDecimal amount;
    private final Currency currency;
    
    // Immutable - return new instance
    public Money add(Money other) {
        return new Money(amount.add(other.amount), currency);
    }
    
    // Equality based on attributes
    public boolean equals(Object o) {
        Money m = (Money)o;
        return amount.equals(m.amount) && currency.equals(m.currency);
    }
}
```

### Aggregate
**Definition**: A cluster of entities and value objects with a consistency boundary. One entity is the aggregate root.

**Characteristics**:
- Has a root entity (aggregate root)
- Enforces invariants (business rules)
- External access only through root
- Atomic unit for persistence
- Internal objects can't be referenced externally

**Example**: Order (root) with OrderLines (internal)
```java
class Order {  // Aggregate Root
    private OrderId id;
    private CustomerId customerId;
    private List<OrderLine> lines;  // Internal to aggregate
    private Money total;
    
    // Public method enforces invariant
    public void addLine(Product product, int quantity) {
        if (quantity <= 0) throw new InvalidQuantityException();
        lines.add(new OrderLine(product, quantity));
        recalculateTotal();  // Maintain invariant
    }
    
    // External code cannot modify lines directly
    public List<OrderLine> getLines() {
        return Collections.unmodifiableList(lines);
    }
}
```

### Repository
**Definition**: Abstraction for aggregate persistence that acts like an in-memory collection.

**Characteristics**:
- One repository per aggregate root
- Collection-like interface (add, remove, find)
- Hides persistence mechanism
- Retrieves fully-formed aggregates

**Example**:
```java
interface OrderRepository {
    Order findById(OrderId id);
    List<Order> findByCustomer(CustomerId customerId);
    void save(Order order);
    void delete(Order order);
}
```

### Domain Service
**Definition**: Stateless operation that doesn't naturally belong to an entity or value object.

**When to Use**:
- Operation involves multiple aggregates
- Operation is a significant domain concept
- Calculation doesn't have natural owner

**Example**:
```java
class FundTransferService {  // Domain Service
    public void transfer(Account from, Account to, Money amount) {
        from.debit(amount);    // Each aggregate handles its part
        to.credit(amount);
        // Publish domain event: FundTransferred
    }
}
```

### Domain Event
**Definition**: Something significant that happened in the domain. Past tense.

**Characteristics**:
- Named in past tense (OrderPlaced, PaymentReceived)
- Immutable record of what happened
- Can trigger other actions
- Can be persisted (Event Sourcing)

**Examples**: OrderShipped, PolicyRenewed, ClaimApproved
```java
class OrderPlaced {
    private final OrderId orderId;
    private final CustomerId customerId;
    private final Instant occurredAt;
    private final Money totalAmount;
    
    // Immutable - only constructor
    public OrderPlaced(OrderId orderId, CustomerId customerId, Money total) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.totalAmount = total;
        this.occurredAt = Instant.now();
    }
}
```

### Factory
**Definition**: Encapsulates complex object or aggregate creation.

**When to Use**:
- Complex creation logic
- Aggregate creation involves multiple steps
- Need to maintain invariants during creation

**Example**:
```java
class OrderFactory {
    public Order createOrder(Customer customer, ShoppingCart cart) {
        // Complex creation logic
        validateCustomer(customer);
        Order order = new Order(customer.getId());
        cart.getItems().forEach(item -> 
            order.addLine(item.getProduct(), item.getQuantity())
        );
        applyPromotions(order, customer);
        return order;
    }
}
```

### Specification
**Definition**: Encapsulates business rules for querying or validation.

**When to Use**:
- Complex business rule combinations
- Rules used in multiple places
- Need to test business logic independently

**Example**:
```java
interface Specification<T> {
    boolean isSatisfiedBy(T candidate);
}

class PremiumCustomerSpecification implements Specification<Customer> {
    public boolean isSatisfiedBy(Customer customer) {
        return customer.getTotalPurchases().isGreaterThan(Money.dollars(10000))
            && customer.getAccountAge().isGreaterThan(Years.of(2));
    }
}
```

## Layered Architecture (DDD Style)
```
┌─────────────────────────────────────┐
│   User Interface / Presentation     │  ← HTTP controllers, views, DTOs
├─────────────────────────────────────┤
│   Application Layer                 │  ← Use cases, application services
├─────────────────────────────────────┤
│   Domain Layer                      │  ← Entities, Value Objects, Services
│   (The Heart)                       │     Aggregates, Domain Events
├─────────────────────────────────────┤
│   Infrastructure Layer              │  ← Persistence, external services
└─────────────────────────────────────┘
```

**Domain Layer**: 
- No dependencies on other layers
- Pure business logic
- Framework-agnostic
- Most important layer - protect it!

## Claude Guidelines for Applying DDD

### During Requirements/Analysis:
1. **Identify domain concepts**: "What are the key business concepts?"
2. **Build ubiquitous language**: "What does the domain expert call this?"
3. **Find entities**: "What needs identity? What changes but remains the same?"
4. **Find value objects**: "What's defined purely by its attributes?"
5. **Discover aggregates**: "What consistency boundaries exist?"
6. **Identify domain events**: "What significant things happen?"

### During Architecture/Design:
1. **Define bounded contexts**: For large systems, identify context boundaries
2. **Map contexts**: How do contexts relate? Anti-corruption layers needed?
3. **Identify core domain**: What provides competitive advantage?
4. **Design aggregates**: What are the transaction boundaries?
5. **Plan repositories**: One per aggregate root
6. **Consider domain events**: For cross-aggregate/cross-context communication

### During Implementation:
1. **Use ubiquitous language**: In all names and comments
2. **Enforce invariants**: In aggregate roots
3. **Keep domain pure**: No persistence/UI concerns in domain layer
4. **Implement domain services**: For multi-aggregate operations
5. **Create value objects**: Immutable, with business meaning
6. **Emit domain events**: When significant things happen

### During Code Review:
1. **Check ubiquitous language**: Does code match business terms?
2. **Find anemic models**: Is logic in services instead of domain objects?
3. **Verify aggregate boundaries**: Are invariants protected?
4. **Spot missing concepts**: Are there implicit concepts that should be explicit?
5. **Review layering**: Is domain layer pure? Any leaked persistence concerns?

## Common Patterns to Recognize

### Anemic Domain Model (Anti-Pattern)
```java
// BAD - Anemic (just data, no behavior)
class Order {
    private List<OrderLine> lines;
    public List<OrderLine> getLines() { return lines; }
    public void setLines(List<OrderLine> lines) { this.lines = lines; }
}

class OrderService {
    public void addLine(Order order, Product product, int quantity) {
        order.getLines().add(new OrderLine(product, quantity));
        // Business logic in service, not domain object!
    }
}

// GOOD - Rich Domain Model
class Order {
    private List<OrderLine> lines;
    
    public void addLine(Product product, int quantity) {
        if (quantity <= 0) throw new InvalidQuantityException();
        lines.add(new OrderLine(product, quantity));
        // Business logic in domain object where it belongs
    }
}
```

### Making Implicit Concepts Explicit
```java
// IMPLICIT - using primitives
class Customer {
    private String email;  // Just a string
    
    public void changeEmail(String newEmail) {
        this.email = newEmail;  // No validation
    }
}

// EXPLICIT - Email as value object
class Email {
    private final String value;
    
    public Email(String value) {
        if (!isValid(value)) throw new InvalidEmailException();
        this.value = value;
    }
    
    private boolean isValid(String email) {
        // Validation logic
    }
}

class Customer {
    private Email email;  // Type-safe, validated
    
    public void changeEmail(Email newEmail) {
        this.email = newEmail;  // Already validated
    }
}
```

## Integration with SWECOM Skills

### Requirements Engineering (SWECOM 1)
- **DDD Adds**: Ubiquitous language discovery, domain modeling workshops, event storming
- **Focus**: Finding entities, value objects, aggregates, and domain events

### Design (SWECOM 2)
- **DDD Adds**: Tactical patterns as primary design approach
- **Focus**: Rich domain models, not anemic data structures

### Construction (SWECOM 3)
- **DDD Adds**: Implementation patterns for entities, value objects, aggregates
- **Focus**: Keeping domain layer pure and expressive

### Testing (SWECOM 4)
- **DDD Adds**: Testing business rules, testing aggregates maintain invariants
- **Focus**: Tests express business scenarios in ubiquitous language

### Software Systems Engineering (SWECOM 7)
- **DDD Adds**: Bounded contexts, context mapping for large systems
- **Focus**: Strategic design for system decomposition

### Architecture (Your skill)
- **DDD Becomes**: Primary approach for domain-focused architecture
- **Focus**: Layered architecture with protected domain layer

## Example Conversation

**User**: "Design a system for an insurance company to manage policies"

**Claude applies DDD**:

1. **Strategic Questions**:
   - "What's your core domain? Underwriting? Claims? Both?"
   - "Are there distinct bounded contexts? (Underwriting, Claims, Billing, Customer Management)"

2. **Discover Entities**:
   - Policy (has identity, changes over time)
   - Claim (has identity, lifecycle)
   - Customer (has identity)

3. **Discover Value Objects**:
   - Money (premium amounts)
   - DateRange (coverage period)
   - Address
   - PolicyNumber

4. **Identify Aggregates**:
   - Policy aggregate (Policy root + Coverages + Riders)
   - Claim aggregate (Claim root + ClaimItems)

5. **Find Domain Events**:
   - PolicyIssued
   - PolicyRenewed
   - ClaimFiled
   - ClaimApproved

6. **Design**:
```java
// Policy Aggregate
class Policy {  // Aggregate Root
    private PolicyId id;
    private CustomerId customerId;
    private List<Coverage> coverages;
    private Money premium;
    private DateRange effectivePeriod;
    
    public void addCoverage(CoverageType type, Money limit) {
        // Enforce invariants
        if (effectivePeriod.hasStarted()) 
            throw new CannotModifyActivePolicyException();
        coverages.add(new Coverage(type, limit));
        recalculatePremium();
    }
    
    public void renew() {
        // Business logic
        effectivePeriod = effectivePeriod.extendByOneYear();
        // Emit domain event
        DomainEvents.raise(new PolicyRenewed(this.id));
    }
}
```

## Resources

### Essential Reading
- **Eric Evans** - Domain-Driven Design: Tackling Complexity in the Heart of Software (2003)
- **Vaughn Vernon** - Implementing Domain-Driven Design (2013)
- **Eric Evans** - Domain-Driven Design Reference (free PDF at domainlanguage.com)

### Online Resources
- DDD Reference: https://www.domainlanguage.com/ddd/reference/
- DDD Community: https://www.domainlanguage.com/community/

### Key Concepts Summary
- **Strategic**: Bounded Contexts, Context Maps, Core Domain, Ubiquitous Language
- **Tactical**: Entity, Value Object, Aggregate, Repository, Domain Service, Domain Event, Factory

## Anti-Patterns to Avoid

1. **Anemic Domain Model**: All logic in services, domain objects are just data
2. **Breaking Aggregate Boundaries**: External code modifying internal aggregate objects
3. **Over-engineering Simple Domains**: Applying full DDD to CRUD apps
4. **Ignoring Bounded Contexts**: Single model for entire large system
5. **Technical Coupling**: Persistence concerns leaking into domain layer
6. **Premature Patterns**: Applying patterns before understanding the domain
7. **Smart UI Anti-Pattern**: Business logic in presentation layer

## When Claude Should Suggest DDD

### Strong Signals for DDD:
- User mentions complex business rules
- Domain experts are available
- Long-term system evolution expected
- Business logic is competitive advantage
- Multiple interconnected business concepts
- Phrases like "business rules", "domain expert", "complex workflow"

### Weak Signals Against DDD:
- "Simple CRUD app"
- "Just need to store and retrieve data"
- "Quick prototype"
- "Technical problem" (not business problem)
- No domain expert access

## Summary

Domain-Driven Design is a methodology for tackling complexity in software through:
1. **Strategic Design**: Bounded Contexts, Core Domain identification
2. **Tactical Design**: Rich domain models using patterns (Entity, Value Object, Aggregate, etc.)
3. **Ubiquitous Language**: Shared vocabulary in code and conversations
4. **Protected Domain Layer**: Business logic isolated from technical concerns

Apply DDD when domain complexity is high and business rules provide competitive advantage. Use tactical patterns to build rich, expressive domain models that reflect the business.
