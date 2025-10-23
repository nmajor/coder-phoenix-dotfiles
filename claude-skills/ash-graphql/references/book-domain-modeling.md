To my wife Devy, my daughter Chaaru, and my mom Saroja—the three important
women in my life.
— Shankar Dhanasekaran (@shankardevy)

ii

Gratitude Note
I’ll forever cherish writing this book with my dad—or as I affectionately call him in
my regional language, dada. I’m beaming with pride and gratitude that this book
was authored by a father-son duo. Thank you for trusting me to write this book and
for being such a wonderful guide throughout my life. Thank you for everything,
dada!
I’m deeply grateful to my grandmother Saroja, my mom Devy, and my sister
Chaaru. Your care, encouragement, and support were essential not just in
completing this book but throughout all the important stages of my life.
I’m thankful to my teammates Sakthi, Vikram, and Rashmi for helping me make
time to write this book and for their constant support.
I’m also indebted to the Ash community, which has deepened my understanding of
the framework. The way everyone comes together to build and grow Ash is truly
inspiring.
— Nittin
When it takes a whole village to raise a child, what does it take to write a book?
I’m grateful to Zach Daniel and the core team for creating Ash and releasing it for
everyone. Without your work, this book would not exist. Thank you, Zach, for your
constant, friendly support on the Elixir Forum. I have learned so much from your
answers to everyone’s questions about Ash.
I’m grateful to my family members who sacrificed their personal time with me as I
went into a marathon-sprint mode of writing this book with release dates
approaching. Thank you, Devy, for being my personal assistant; Chaaru, Nittin,
Amma, and Anna for your understanding and support in accommodating my
countless requests as I wrote this book.
• Thank you, Anna, for your unwavering support from the initial brainstorming
of the book to its final publication. Your critical feedback and attention to every
minor detail shaped this book into what it is today.

iii

• Thank you, Nittin, for being my co-author and collaborating joyfully as we
made several major pivoting decisions during the writing process, subjecting
yourself to various experiments. Readers may only see the final book and not
the work you scrapped as part of these experiments, but I’m thankful for your
support. Without these experiments, writing a book on a feature-rich, complex
framework like Ash would not have been possible.
I’m grateful to dear friends and teammates who helped with this book. Thank you,
Rashmi, for the cover design, Figma prototypes, and always being available to
provide support. Sakthi, thank you for helping with the code snippets in the book,
and Vikram, for accommodating your work around my availability.
The list goes on, and I hold deep gratitude in my heart for many others who aren’t
mentioned here but played an important role, either directly or indirectly.
— Shankar Dhanasekaran (@shankardevy)

iv

Contents
Dedication . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ii
Gratitude Note . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . iii
Philosophy of This Book . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xi
README! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xiii
What Is the Tuesday Project?

xiv

1. Marketing Ash for Your Benefit . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
1.1. Community Size Challenges

1

1.2. Inherent Challenges

2

1.3. Why Ash Solves Real Problems

2

2. Ash Domain & Resources . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 8
2.1. What is Domain Modeling?

8

2.2. What is Ash Resource?

12

2.3. What is Ash Domain?

12

2.4. How do I create a simple Domain?

12

2.5. How do I define a resource in Ash?

13

2.6. How do I decide which resources belong to which Domain? How many
domains do I need?

15

2.7. Summary

17

3. Attributes & Identities . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 18

v

3.1. What is a Resource Attribute?

18

3.2. How do I define attributes?

19

3.3. How do I create database columns based on my attribute config?

20

3.4. How do I name an attribute different from db column name?

22

3.5. How is Ash related to Ecto.Schema?

23

3.6. How do I set a primary key for a resource in Ash?

24

3.7. How do I mark attributes that are generated at data layer?

26

3.8. How do I define timestamp attributes?

28

3.9. How do I set default values for attributes in Ash?

30

3.10. What does match_other_defaults option do?

32

3.11. How do I restrict an attribute from being written?

36

3.12. How do I enforce constraints on attributes in Ash?

38

3.13. How do I restrict sensitive field values from being inspected?

39

3.14. What are identities and How do I define it?

40

3.15. How do I define multi-attribute identities in Ash?

41

3.16. Anatomy of Attributes

42

3.17. Summary

43

4. Ash.Query . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 45
4.1. How to create a simple query?

46

4.2. How do I filter data?

48

4.3. What’s the difference between filter and filter_input?

49

4.4. Why don’t we see the resultant data when using Ash.Query?

51

4.5. How do I select only a specific field?

53

4.6. Ensuring Fields Are Included with ensure_selected/2

53

4.7. Removing Fields with deselect/2

55

4.8. Checking Field Selection with selecting?/2

55

4.9. Sorting Data with sort/3

56

4.10. Handling User-Provided Sorting with sort_input/3

57

4.11. Limiting Results with limit/2

58

4.12. Skipping Results with offset/2

59

4.13. What is the difference between Ash Query and Ecto Query?

60

4.14. What are Ash.Query escape hatches?

61

4.15. Putting It All Together with Ash.Query.build

61

4.16. Summary

63

5. Changeset . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 65
5.1. What is Ash Changeset?

65

5.2. Understanding the Ash Changeset struct

68

5.3. How to create a new changeset and insert or update a record using it? 71
5.4. Changing an Attribute with change_attribute/3

76

5.5. Applying Multiple Attribute Changes with change_attributes/2

77

5.6. Forcing Attribute Changes with force_change_attribute/3

77

5.7. Checking Attribute Changes with changing_attribute?/2

79

vi

5.8. Checking Any Attribute Changes with changing_attributes?/1

79

5.9. Inspecting Changes with fetch_change/2

80

5.10. Modifying Changes with update_change/3

81

5.11. Applying Changes with apply_attributes/2

82

5.12. Clearing Changes with clear_change/2

82

5.13. Adding Errors with add_error/3

82

5.14. Summary

83

6. Actions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 85
6.1. What are Default and Primary Actions?

85

6.2. How Do I Define a read Type Action in Ash?

87

6.3. What is the Difference Between Action Type and Action Name?

89

6.4. How do I Filter Read Actions in Ash?

93

6.5. What is a Resource Preparation?

94

6.6. How to Set or Update Attributes in Create or Update Actions?

95

6.7. Using the argument Directive to Define Inputs

96

6.8. Transforming Data with the change Directive

97

6.9. How do I Manage the Fields Selected in Read Action?

99

6.10. How do I Ensure Mandatory Fields are Always Loaded in My Read
Action?

100

6.11. How do I Paginate Read Actions in Ash?

100

6.12. Keyset Pagination

103

6.13. Summary

105

7. Action LifeCycle Callbacks . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 106
7.1. How to Define before_action for a Read Action?

107

7.2. How to Define after_action for a Create Action?

115

7.3. Summary

117

8. Code Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 119

vii

8.1. What is a code interface and how do I define one in Ash?

119

8.2. Creating Domain Code Interface Manually

121

8.3. Creating Domain Code Interface Automatically

122

8.4. Defining Code Interface Function On Resource

124

8.5. Summary

125

9. Relationships . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 127
9.1. What is a Resource Relationship?

127

9.2. How to Define a belongs_to Relationship?

127

9.3. How to Define a has_many Relationship?

131

9.4. How to Define has_one Using has_many Relation?

134

9.5. How to Define a many_to_many Relationship?

135

9.6. How Do We Define a Self-Referencing Relationship in Ash?

137

9.7. How Do We Create a Relationship Without a Foreign Key?

138

9.8. How Do We Define a Manual Relationship?

139

9.9. How to Add Filters to Relationship?

141

9.10. How Do We Use Filters on Relationships in Ash Actions?

142

9.11. How to Load Relationships in a Read Action in Ash?

143

9.12. Managing Related Data

146

9.13. How to Create Related Data from the Parent Resource?

148

9.14. How to Update Related Data?

151

9.15. How to Delete Related Data?

153

9.16. How to Affect Related Data Based on Identities?

155

9.17. Summary

158

10. Aggregates . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 159
10.1. What is a Resource Aggregate?

159

10.2. How do I define a count aggregate?

160

10.3. How do I define an exists aggregate?

162

10.4. How do I define a sum aggregate?

164

10.5. How do I define a max and min aggregate?

167

10.6. How do I define an avg aggregate?

168

10.7. How do I define a list aggregate?

169

10.8. How do I define a first aggregate?

169

10.9. How do I load aggregates in queries in Ash?

170

10.10. How do I filter based on aggregates in Ash?

172

10.11. Summary

173

11. Calculations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 174
11.1. What is a Resource Calculation?

174

11.2. How do I define calculations using expr?

175

viii

11.3. How do I use calculations in filters in Ash?

177

11.4. How do I define calculation using fragments?

179

11.5. How to use Aggregates in Calculations?

180

11.6. Summary

184

12. Notifier . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 186
12.1. How do notifiers differ from writing code in our action to perform
tasks after it runs?

187

12.2. Do Ash Notifiers guarantee our side effects at all times?

187

12.3. How to create a simple working Ash Notifier?

188

12.4. What is PubSub Notification and how to configure it with Ash?

191

12.5. How to setup and test broadcast using IEx shells?

191

12.6. How does Ash.Notifier.PubSub work in our Ash application for
broadcasting project creation?

193

12.7. Summary

200

13. Policies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 202
13.1. What is a Resource Policy?

202

13.2. What are Policy Checks?

207

13.3. What are the different Policy Checks available?

208

13.4. What is an actor and how to set it?

211

13.5. How do I authorize an action based on a specific attribute of the
actor?

214

13.6. What is the difference between relating_to_actor and
relating_to_actor_via?

215

13.7. What is a Policy Group?

216

13.8. What is a Policy Bypass and when to use it?

217

13.9. How to create a Custom Policy Check?

218

13.10. Summary

223

14. Multitenancy . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 225
14.1. What is a tenant?

225

14.2. Enabling Multitenancy in Tuesday

226

14.3. Making Indirectly Related Resources Multitenant-Aware in Tuesday 227

ix

14.4. How to set the Tenant for CRUD Operations in Tuesday?

228

14.5. Summary

231

15. Ash Generator . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 233
15.1. How to create Generator module?

233

15.2. Can this Generator be used in Dev environment?

234

15.3. Direct Data Seeding with seed_generator/2

235

15.4. Unique Value Generation with sequence

236

15.5. One-Time Value Generation with once

238

15.6. Randomized Data with StreamData

239

15.7. Composing Generators for Complex Data

241

15.8. Custom Utility Functions

241

15.9. Writing more enjoyable tests

242

15.10. How to use our test helper?

244

15.11. Summary

246

16. Testing Ash Code . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 248
16.1. Why do we write tests?

248

16.2. How to write tests in general?

249

16.3. Tuesday Tests

256

16.4. Summary

257

Conclusion . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 259

x

Philosophy of This Book
This book is built on a set of guiding principles designed to make learning the Ash
framework both effective and engaging. Below, we outline the philosophy that
shapes our approach to teaching, which we follow in both our training sessions and
this book.

Active Learning
Our teaching style is rooted in the belief that "learning the hard way is the easy
way." When Shankar began learning Ruby, he was captivated by the book Learn
Ruby the Hard Way. Though typing out each exercise was challenging, the hands-on
process proved deeply rewarding. While this book doesn’t strictly follow the "Learn
X the Hard Way" pattern, it embraces one of its core principles: active learning.
We encourage you to engage with this book by running the provided code examples
on your machine. To facilitate this, we have taken every effort to ensure all IEx
shell code in the book is directly runnable on your machine and is fully complete.
Active participation will solidify your understanding and make the learning process
more impactful. We encourage you to pause as you read, type the code from the
book into your IEx shell, and experiment as you learn.

Keep It Simple
With the rapid pace of technological growth, there’s already a lot to learn. We
respect your time by keeping this book concise and scannable. Long, essay-style
chapters can be overwhelming, so we’ve structured the content around three
straightforward question types:
• What is X?
• How do I do Y?
• How does Ash make Z work internally?
For example:
1. What is an Attribute (X)?

xi

2. How do I hide a sensitive attribute? (Y)
3. How does Ash’s uuid_primary_key macro (Z) work internally?
The first two sets of questions (X and Y) are practical in nature. This format allows
you to quickly find topics for a deep dive or locate solutions to specific problems
you’re facing at work. Complex concepts are broken into manageable chunks,
making them easier to understand and apply. The last set of questions (Z) offers
deeper dives into Ash internals, demystifying its magic and empowering you as a
developer.

Real-World Relevance
Abstract "hello world" examples often fall short when learning complex
frameworks. Real-world projects help developers contextualize concepts and grasp
ideas that might otherwise feel elusive. To illustrate Ash’s features, this book uses a
comprehensive project management application called Tuesday as a running
example.
Tuesday is a fully functional project management app (without a web UI) included
with this book. We encourage you to explore its source code, experiment with it,
and even extend it to deepen your learning. Released under the permissive MIT
license, Tuesday is also available for use in your own commercial projects.

We’d Love to Hear From You
Please reach out to us at feedback@devcarrots.com to speak to one of the authors
directly. Shankar and Nittin will be happy to read your email and respond
personally.

xii

README!
This section introduces the structure, approach, and practical details for using this
book. Please do not skip this chapter, as many of the questions, answers, and code
examples may not make sense without it.

Hybrid Approach
As we began writing this book, we faced a decision about its teaching style. The
options we considered were cookbook-style and project-based learning.
Cookbook-style books provide quick solutions to specific questions, making them
ideal for addressing immediate learning needs. I’ve always valued this format for
its directness. However, the isolated nature of each question and answer often
creates gaps when trying to understand how concepts apply to a larger, cohesive
project.
In contrast, project-based learning books, where you build a product from scratch,
immerse you in a real-world context but can introduce distractions. The focus often
shifts to product-specific details rather than the core concepts you’re trying to
master. Moreover, covering a large project in depth risks being either
superficial—glossing over real-world complexities—or repetitive, as similar
patterns (like defining attributes for multiple resources) are explained repeatedly.
This book adopts a hybrid approach, combining the strengths of both styles to teach
the Ash framework effectively. The Tuesday app, a fully functional project
management application, serves as our real-world anchor, providing context for
Ash’s features. Instead of building Tuesday from scratch in every chapter, we start
with a complete, working version of the app. Each chapter then explores specific
code within Tuesday to illustrate key Ash concepts, such as resources, actions, or
policies. This approach keeps the focus on Ash without burdening you with
repetitive setup or UI code. By diving into a pre-built project, you see how concepts
fit into a production-like system, while the chapter-by-chapter breakdown ensures
clarity and depth, much like a cookbook’s targeted solutions.

xiii

What Is the Tuesday Project?
Tuesday is a fictional project management application designed to demonstrate the
Ash framework’s capabilities in a real-world context.
Tuesday is a multi-tenant SaaS app enabling teams to collaborate on projects,
manage tasks, and organize team structures, all without a user interface to keep the
focus on Ash’s backend features. All features in the app are organized into three
core domains—Auth, Workspace, and Projects—each containing entities that
handle specific aspects of the system. Below, we describe each resource and its
purpose in simple terms.

Domain: Tuesday.Auth
The Auth domain contains entities related to authentication in Tuesday. In a realworld scenario, there would be additional entities like UserToken, UserSetting, and
others.
Resource: User
Represents an individual using the app. It stores their unique email to authenticate
them and connect them to different organizations. We keep it intentionally simple,
collecting only the email address. This balances mimicking real-world complexity
while avoiding unnecessary noise in learning Ash. In a real-world app, this entity
would include more fields and relationships to store passwords, token credentials,
or other metadata. For our purpose, an email address is sufficient.
Attributes:
1. email: Stores the user’s unique email address.
Relationships:
1. None directly defined in this resource.

Domain: Tuesday.Workspace
The Workspace domain holds entities related to organizations signing up to use

xiv

Tuesday. It includes two entities:
1. Organization
2. OrganizationMember
Resource: Organization
Defines a team or company using Tuesday. It holds details like the team’s name,
subscription plan, and whether members can create projects.
Attributes:
1. name: Holds the organization’s name (e.g., “DevCarrots”).
2. plan_type: Specifies the subscription level (e.g., free, premium).
3. can_standard_member_create_project: A boolean indicating whether
standard role members can create projects.
4. created_at, updated_at: Tracks when the record was created or updated.
Relationships:
1. has_many :projects: Connects to projects in the Projects domain.
2. has_many :members: Links to OrganizationMember records.
Resource: OrganizationMember
Connects a user to an organization, specifying their role (e.g., admin, member),
username, and status within that team. It allows one user to participate in multiple
organizations with different roles.
Attributes:
1. username: Stores the member’s display name in the organization.
2. role: Defines their role (e.g., admin, member).
3. status: Shows whether they’re active or inactive in the team.

xv

Relationships:
1. belongs_to :user: Ties to a User in the Auth domain.
2. belongs_to :organization: Links to an Organization.
3. has_many :projects: Connects to projects they participate in.
4. has_many :tasks: Links to tasks assigned to them.

Domain: Tuesday.Projects
The Projects domain manages entities related to the projects and tasks that the
organization handles within the Tuesday app. It includes five entities:
1. Project
2. ProjectMembership
3. Task
4. TaskAssignee
5. Comment
Resource: Project
Represents a project within an organization, including its name, description, dates,
and status (e.g., active, completed). It groups tasks and members together.
Attributes:
1. name: Stores the project’s title.
2. description: Provides a brief overview.
3. start_date, due_date: Records key planning dates.
4. status: Tracks whether the project is active, archived, or completed.
Relationships:
1. belongs_to :organization: Ties to an Organization in the Workspace
domain.

xvi

2. has_many :tasks: Links to tasks within the project.
3. has_many :project_members: Connects to ProjectMembership.
Resource: ProjectMembership
Links organization members to a specific project, indicating who is involved in the
project’s work.
Attributes:
1. project_id, member_id: Stores IDs to join projects and members.
Relationships:
1. belongs_to :project: Links to a Project.
2. belongs_to :member: Connects to an OrganizationMember.
Resource: Task
Defines a unit of work within a project, with details like title, description, priority,
and deadlines. Tasks can have sub-tasks and be assigned to members.
Attributes:
1. title: Holds the task’s name.
2. description: Details what the task involves.
3. is_complete: A boolean indicating the status.
4. priority: Shows the task’s urgency.
5. start_date, due_date: Tracks scheduling details.
Relationships:
1. belongs_to :project: Ties to a Project.
2. belongs_to :parent_task: Links to a parent task for sub-tasks.
3. has_many :sub_tasks: Connects to child tasks.

xvii

4. has_many :comments: Links to task discussions.
5. has_many :assignees: Connects to members via TaskAssignee.
Resource: TaskAssignee
Connects a task to organization members, showing who is responsible for
completing it. A task can have multiple assignees.
Attributes:
1. task_id, member_id: Stores IDs to join tasks and members.
Relationships:
1. belongs_to :task: Links to a Task.
2. belongs_to :member: Connects to an OrganizationMember.
Resource: Comment
Captures discussions on a task, storing the comment’s text and linking it to the task
and the team member who wrote it.
Attributes:
1. body: Contains the comment’s text.
Relationships:
1. belongs_to :task: Ties to a Task.
2. belongs_to :author: Links to the OrganizationMember who wrote it.

Domain: Tuesday.Playground
Provides a simple domain and resources for experimenting with Ash features,
allowing quick exploration without engaging with Tuesday’s complex project
management structure. This domain includes several resources not directly related
to Tuesday. These modules are explained in detail in the relevant chapters.

xviii

No UI but Figma Prototype
The Tuesday app bundled with this book has no user interface, and this is
intentional. It includes all the models, relationships, policies, actions, and seed data
you’d expect in a production-ready app, but it omits Phoenix LiveView or
controller-based templates. This enables us to focus solely on mastering the Ash
framework without the distraction of lengthy UI code. To help you visualize the
client requirements and user stories modeled in Ash, we’ve included screenshots of
various features, which clarify the context behind the backend implementation. We
also provide a low-fidelity Figma prototype illustrating Tuesday’s features, which
you can view here.

Developer Persona - Chaaru
Throughout the book, we include Chaaru, a developer persona with technical
requirements or questions related to Ash. In our mind, Chaaru is an experienced
Phoenix developer with expertise in Ecto and/or other frameworks like Ruby on
Rails. Chaaru is new to Ash and tasked with building Tuesday. She is also hesitant to
adopt Ash, as it’s entirely new to her, and prefers using Phoenix with Ecto, where
she feels confident.

How to Use This Book with the Tuesday Project
As you read the chapters, you may want to refer to the previous section, "What Is
the Tuesday Project?", to refresh your memory of the overall app structure. Each
chapter focuses on a specific Ash concept, starting with foundational “What is…?”
questions, such as “What is an Ash Changeset?” These sections provide a clear
conceptual understanding before moving to practical “How do I…?” questions, like
“How do I define and perform create actions in Ash?”
For the “How do I…?” sections, we anchor the explanations in user stories from the
Tuesday project. Each user story builds on Tuesday’s structure, adding details to
the business requirements and demonstrating how Ash addresses them. This
approach ensures you understand both the why behind a feature and the how of
implementing it in a real-world context.
For example, when explaining “How do I define and perform create actions in
Ash?”, we might use a user story from Tuesday, such as enabling a team member to

xix

create a new project within their organization. We’ll outline the business
need—say, ensuring only authorized members can start projects—and then show
how Ash’s create actions are defined and executed to meet this requirement,
connecting the code directly to Tuesday’s functionality.
While the book includes relevant code snippets for specific topics from Tuesday
and sometimes builds them step by step, the complete working code, covering
features explained across chapters, is available in the Tuesday code repository.
Keep a running instance of the Tuesday app on your machine as you read the book
to quickly experiment with the code in your IEx shell terminal.
In all IEx shell code shown in this book, we have included the
authorize?:

false option when invoking functions such as

Ash.create or domain functions like Projects.list_tasks.
Tuesday is fully configured with Ash policy checks. With these
policy checks enforced, we must first fetch the appropriate actor
who is permitted to perform the action and then pass this actor as
the actor option in all function calls. This process can be timeconsuming when reading this book and wanting to quickly try out a
function. For convenience, we have included authorize?: false
in all IEx shell code provided in this book. In production, using this
option should be avoided unless you fully understand the
implications of bypassing authorization.

Machine Setup Basics
To run the Tuesday project and follow the book’s examples, you’ll need a properly
configured development environment. This includes installing Elixir, Erlang, and
any dependencies required by Ash and the Tuesday project. This book assumes you
already have Elixir and Phoenix running on your machine for other projects. To
run the Tuesday project locally, clone it from Tuesday Git Repository and follow the
setup steps in its README.
If you’re new to Elixir and Phoenix, instead of repeating setup instructions here, we
refer you to the following online resources for the most up-to-date guidance:

xx

• Elixir Installation: Visit https://elixir-lang.org/install.html for platform-specific
instructions.
• Ash Framework Setup: Check the official Ash documentation at https://ashhq.org for dependency setup.
These resources ensure a smooth setup experience, allowing you to focus on
learning Ash.

xxi

Chapter 1. Marketing Ash for Your Benefit
"Marketing is the generous act of helping someone solve a problem. Their
problem." — Seth Godin
Let’s keep this direct: in this chapter, we want to sell you on Ash. Not because we, as
the authors, gain anything from Ash Framework’s success directly, but because
we’re developers like you. We’ve used Ash ourselves, and it has significantly
improved our productivity. We want to help you solve your problems, and we
genuinely believe Ash is a game changer—whether you’re building small apps or
large systems.
This chapter addresses common concerns about adopting Ash for your project and
demonstrates how it solves real-world challenges, drawing on our experiences.
These concerns broadly fall into two categories:
1. temporary issues tied to Ash’s small but growing community, which will
resolve on its own as the community expands, and
2. misconceptions about Ash’s purpose, which will persist until we shift our
perspective to understand the complex business logic problems Ash is designed
to solve.
Our goal is to convince you that Ash is worth your time.

1.1. Community Size Challenges
Some challenges stem from Ash’s relatively small but growing community. These
are temporary issues and let these not stop you from using Ash. Doing this causes a
viscious feedback loop which is difficult to get out.
1. Inadequate learning resources - fewer tutorials compared to Elixir’s ecosystem.
2. Documentation can be difficult to read - though improvements are ongoing.
3. Fewer experts in Ash - limited support compared to Phoenix or Ecto.

1

Ash’s creator, Zach Daniel, and core team members like Rebecca Le are active on
the Elixir Forum, answering questions daily. We’ve seen bugs addressed within an
hour, sometimes with a minor version bump—a level of support we’ve rarely
experienced. The documentation is improving, with one book published by the Ash
creators and this book as another step towards making Ash more accessible.
Ofcourse, we need more and that’s where we need you to grow Ash’s community
and its support. By seeing past the learning curve and experiencing Ash’s benefits,
our hope is that you’ll help accelerate its momentum.

1.2. Inherent Challenges
Other challenges are tied to Ash’s ambitious goals:
1. New concepts: Resources, actions, and policies require learning.
2. Declarative style: Configuring code feels unfamiliar.
3. Perceived “magic”: It’s not always clear what happens behind the scenes.
If any of the above reasons stop you from adopting Ash, then it’s probable that you
are using a wrong lens to see what Ash does. These perceived challenges will never
go away from Ash because these are infact the core strength of Ash as we see
below. The solution here is to do the right kind of comparison to understand what
benefit Ash gives you and you will be able to automatically acknowledge the worth
of spending time to learn Ash. These concerns vanish once you accept to learn Ash
and not fight with it with your previous mental constructs on how to build apps.

1.3. Why Ash Solves Real Problems
Speaking from our personal experience, we, the authors, have worked on largescale projects that started as small prototypes. Nittin and Shankar worked on a
payment service for Auroville that powers the entire township’s digital
transactions. Shankar also worked with startups in synthetic data generation and
worked with sports clubs that processed massive volumes of data. All of these
projects were created with vanilla Phoenix. We had the pleasure of working on a
greenfield project using our favorite framework but the pleasure was short lived
due to growing complexity.

2

In 2024, we started using Ash for our newer projects and after a year now, we could
retrospectively feel how much Ash would have relieved the pain in our previous
projects. Unfortunately, Ash wasn’t available when we started working on those
projects and if we are to restart doing the same projects from scratch, we would do
it in Ash. We have spoken to different people in the community, some of whom are
startup founders and they don’t immediately see the benefit of Ash but rather see
obstacles in using Ash. This is primarily due to the reference point of comparison
chosen by them.
The reference point of comparison should not be "how easy or difficult it’s to create
a new project" in vanilla Phoenix vs Phoenix with Ash
rather it should be "how easy or difficult it’s to manage this project as it matures
with all its complexities" in vanilla Phoenix vs Phoenix with Ash.
Once we establish a clear point of comparison, we can truly comprehend the
advantages of Ash and also recognize the necessity of why Ash must introduce
novel concepts, adopt a declarative style, and all the enchanting elements that
accompany it.
In the following section, we will use these experiences to illustrate three significant
pain points that Ash effectively addresses.
Problem 1: Onboarding New Developers
In all these projects using vanilla Phoenix, we consistently noticed how difficult it is
to onboard new developers later in the lifecycle. Even with decent test coverage
and documentation, a lot of the critical knowledge lives only in the heads of longterm contributors.
For example, in Auroville’s payment service, new developers struggled to
understand custom logic scattered across contexts, or even understand the purpose
of a simple attribute named channel_reference_id because it’s not clear what it
refers here, slowing their ramp-up. Developers don’t know where to start to
understand a huge codebase. Simple things like field names that we defined in our
payment service were not meaningful enough for the new developers to
understand. We had a spaghetti of inline comments to explain what those did,
inventing our own framework.

3

With Ash, we now have a clear structure to our code. Each Ash resource contains
the information needed for new developers to understand what each of these
entities do. The description macro allows us to document any piece of
information that we have on our resource module. The declarative style, along with
a clean structure in itself is better than reading long pages of documentation or
reading through 1000s of test cases.
Problem 2: Managing Code Complexity
As the product features grew, we—the original developers—struggled with
managing the rising code complexity. Under delivery pressure, we often
compromised best practices in favor of quick hacks or inefficient solutions.
Duplication of code to add new features was favored than refactoring existing ones
or making them composable. These decisions kept coming back to haunt us because
we never got around to fixing them once they were live.
For instance, what started as a simple nice policy check using pattern matched
function in our controllers grew into an ugly unmanageable chore of managing
permissions. Adding and removing permissions was brittle as there were duplicates
due to non-composable policy checking functions.
Ash’s declarative resources act as a single source of truth, reducing duplication.
Defining an entity once generates migrations, APIs, and validations, keeping
complexity manageable. Authorization policy is managed at resource level for all
actions in a highly structured way. Being able to filter on attributes, relationships,
aggregates and calculations using the same method removes the complexity of
managing different join queries for complex operations.
Problem 3: Long-Term Maintenance
From those experiences, we’ve learned that writing a Phoenix app with just plain
Ecto is easy in the beginning—but the complexity grows significantly over time.
Using Phoenix Contexts to organize your business logic works well initially. We
tend to write new functions or modify existing ones as product grows but we need
to remember every piece of code written, including any comments and tests, adds
to the maintenance burden in long term. Anything that is written must be
maintained for long term.

4

Ash reduces the number of implementations we write. We write less code, resulting
in less maintenance. We adhere to a declarative approach, defining what is
required, and centralize this under resources. We don’t duplicate of what has
already been specified to Ash. All implementation details are managed internally
by Ash, relieving us of the maintenance burden.
Phase

Phoenix + Contexts

Phoenix + Ash

Getting Started

Easy setup, minimal

Steeper learning curve for

learning

your very first project

Team Onboarding in early Easy early on

Easier over time due to

stage of the product

conventions

Team Onboarding in later Difficult going forward

For anyone using Ash,

stage of the product

onboarding on new Ash
project should be easy at
any stage as the
framework deals with the
complexity internally

Code Growth
Maintenance

Becomes fragile and

Remains consistent and

harder to evolve

declarative

Manual conventions, more Less bugs and easy
bugs due to

maintenance due to

undocumented custom

reliance on Ash’s

implementation

implementation.

1.3.1. Declarative Design and Ash Magic
Declarative coding in Ash means your app feels like a configuration file where you
specify what you need: “I want a user with an email that’s required and unique.”
Instead of coding every step—database queries, validations, API endpoints—you
define it once in a resource (we discuss what a resource is in detail later in this
book), and Ash handles the rest. It’s a significant shift from traditional apps, where
you often write the same logic repeatedly. With Ash, except for custom validations,
actions, or policies not built into Ash, you’re mostly configuring rather than coding
from scratch.

5

This declarative nature is the very strength of Ash. Ecto is also declarative in design
like Ash but it requires us to declare our requirements in multiple places even if we
have already declared the same requirement elsewhere. For eg., in Ecto, the
developer would define the schema and then also write manually, once again, the
same requirements in the migration file to create the underlying database table
with the same set of constraints that is already defined in Ecto Schema. If the
developer needs a JSONApi for fetching the Ecto records, then the developer would
write again all or subset of the same requirements in the Phoenix layer depending
on the business requirements. Ash flips this on its head with resource files acting as
the single source of truth.
Define a resource like this:
defmodule User do
use Ash.Resource
attributes do
uuid :id
string :email, allow_nil?: false
end
actions do
create :register do
accept [:email]
end
end
end

This resource says: “Users have an email, it’s required, and you can create them.”
From that alone, Ash generates the database migration with the right columns and
constraints—no extra work. Later, if you want a JSON API, Ash’s JSON API extension
(a separate add-on) reads the same resource and spins up endpoints automatically.
If you want GraphQL API, no problem. Just plugin the AshGraphQL library and it
will work seamlessly using the same configuration already defined in the resource
file. No controllers, no duplicate code. One definition, reused everywhere.
While this ability of Ash of doing everything automatically feels like magic and
might make us feel not having control of how things are done, in reality, it’s simply
an efficient way of reusing the data and managing a single source of truth. In this
sense, Ash framework’s slogan "Model your domain and derive the rest" truely

6

conveys how Ash works internally.
Hopefully we have sold you Ash! Now, let’s dive into the practical chapters to learn
Ash hands-on. We can’t wait to see how you will use Ash to make your code cleaner
and your work easier.

7

Chapter 2. Ash Domain & Resources
Ash is a declarative Elixir framework for building application backend. It is a
"batteries included" framework that comes with loads of built-in features in the
core and has a lot of officially supported extensions (20+ at the time of this writing)
that provides even more support. Apart from these, there is a growing number of
community provided extensions.
The Ash Framework is a business domain modeling framework with its official
tagline, “Model the domain, derive the rest.” The tagline for this book is “Build Fast,
Model Right.” You might have heard of data modeling or domain modeling before,
but you might have thought they were the same or understood them vaguely. Since
Ash emphasizes domain modeling, let’s start by clarifying its basic definition.

2.1. What is Domain Modeling?
Domain modeling is the process of creating a conceptual representation of the key
entities, relationships, and rules within a specific business domain. In this book, we
build Tuesday using the Ash Framework, a SaaS product for project management.
Tuesday addresses the business problem of managing large, complex projects for its
customers. At the business level, we focus on the problem domain, not on technical
details like handling HTTP headers, setting cookies, encoding data in JSON format,
or storing data in a PostgreSQL database using database transactions. These
concerns belong to the technical level.
Newcomers to the Elixir ecosystem often confuse Ash with Phoenix and Ecto due to
their overlapping roles in building web applications. To clarify Ash’s role, consider
a full-stack Elixir application, spanning from low-level HTTP protocols to the highlevel business logic that drives the application. The following section briefly
discusses this entire stack, highlighting domain modeling as a key component that
Ash helps us with.

2.1.1. HTTP and WebSocket Layer
Web applications rely on HTTP and WebSocket protocols, where browsers send raw
headers and data to the server. Cowboy or Bandit handles these low-level

8

connections, parsing and managing raw protocol data to provide a foundation for
higher-level frameworks.

2.1.2. Web Request/Response Cycle
Phoenix builds on Cowboy or Bandit, offering abstractions for the request/response
cycle. It provides routing, controllers, and templates to deliver responses in formats
like HTML, JSON, or WebSocket messages, making it ideal for web application
development.

2.1.3. Data Persistence
For data persistence, Phoenix often integrates with Ecto. Ecto manages data
modeling and retrieval, defining schemas and querying databases to ensure
efficient data handling.

2.1.4. Business Domain Modeling - Ash’s Role
While Cowboy, Phoenix, and Ecto focus on technical infrastructure, they do not
fully address the application’s business logic. Phoenix Contexts offer some
organization for business logic but lack a structured approach for comprehensive
domain modeling.
Ash fills this gap by providing a resource-oriented framework to define and
manage business domain logic, including entities, relationships, and rules. It
integrates seamlessly with Ecto (via extensions like AshPostgres) or other data
sources, such as APIs or custom layers.

2.1.5. So what is Domain modeling?
In simpler terms, Domain Modeling involves
• Identifying the core components of a business problem and representing them
in the software. For example, for WhatsApp, the business problem is
"communication between users," and the core components are users, groups,
messages, and so on.
• Defining how these components interact, such as how they relate to each other.

9

• Establishing the rules that govern their behavior, such as validation and
authorization rules.
The goal is to create a clear, organized model that reflects the core concepts and
behaviors of the domain, making the software more maintainable and aligned with
business needs.
Ash framework helps us, the developers, to model domains effectively, creating
software that is both easy to build and maintain. While an e-commerce system
(with entities like products, customers, and orders) differs significantly from a
project management system (with projects, members, and tasks), their underlying
design patterns and challenges share a lot of common ground. For instance, both
require database tables to store entities, validations to ensure data integrity, and
relationships to connect data. Though the specifics of these entities and validations
vary, the need for these low-level components is universal. Ash abstracts these
shared requirements into composable, domain-agnostic elements, enabling
developers to focus on crafting business-specific logic.

2.1.6. What functionality is provided by Ash?
1. Data structures
Ash

allows

developers

to

define

resources,

which

are

declarative

representations of domain entities, such as users, orders, or projects. These
resources encapsulate attributes and serve as the foundation for modeling
complex business domains in a structured and reusable way.
2. Relationships
Ash supports defining relationships between resources, such as one-to-many or
many-to-many connections, using its intuitive DSL. This enables developers to
model complex domain interactions, like linking orders to customers or
projects to team members, with minimal boilerplate.
3. Access Policies
Ash provides a robust policy-based authorization system to control access to
resources and actions at a granular level. Developers can define rules, such as
allowing only managers to dispatch orders, ensuring secure and flexible access
management across the application.
4. Actions

10

Actions in Ash are custom, domain-specific operations (e.g., dispatch_order or
add_member) that encapsulate business logic for creating, updating, deleting or
querying resources. They allow developers to align code with the ubiquitous
language of the business domain, enhancing clarity and maintainability.
5. Calculated fields
Ash supports calculated fields, which are dynamically computed attributes
derived from other data or logic within a resource. This feature enables
developers to include virtual attributes, like a user’s full name or an order’s
total price, without storing them in the database.
6. Data storage
Ash abstracts data storage through configurable data layers, such as
PostgreSQL, ETS, or custom implementations, allowing seamless persistence of
resources. This flexibility ensures developers can adapt storage solutions to
their application’s needs without altering the domain model.
7. Lots and lots of Developer Conveniences
Ash offers numerous developer conveniences, including automatic API
generation (e.g., GraphQL, JSON:API), built-in pagination, filtering, and admin
interfaces. These features reduce boilerplate, accelerate development, and
enhance productivity by providing out-of-the-box tools for common tasks.
These are functionalities provided by the core library, but Ash officially
supports 20+ other libraries which you can see at https://github.com/ashproject/
Very notable features are:
a. Reactor - a dynamic, concurrent, dependency resolving saga orchestrator
b. Cloak - seamlessly encrypt and decrypt resource attributes
c. Archival - implement archival (soft deletion) for resources
d. JSON API - automatically create JSON:API Spec compliant endpoints for the
resources
e. Paper Trail - helps keeping an audit log of changes to your resources
f. GraphQL - extension for building GraphQL APIs with Ash
and several more…

11

2.2. What is Ash Resource?
We already saw what are business entities. For an ecommerce system, these entities
could be Product, Order, Customer, Payment etc while for a Project management
system, these could be Project, Member, Task etc
An Ash Resource is an Elixir module that captures the comprehensive structure and
functionality of these entities using a custom DSL provided by Ash. Resources serve
as the single source of truth for all the data and the behaviour of the domain
entities. It captures the structural information of the entity using attributes,
relationships, identities, aggregates, calculations, multitenancy and
the behaviourial information of the entities through actions and policies.

2.3. What is Ash Domain?
Ash Domain is a simple way to organize the resources. Just like how Elixir Enum
module is a structure to hold functions related to enumerables or List module to
hold functions related to list like items, Domain in Ash is an Elixir module that
holds together other Ash Resources that are logically working as one unit.
By organizing resources into domains, Ash enables developers to structure
applications with clear boundaries, define public functions for all managed
resources in a single place, and provide many other conveniences.

2.4. How do I create a simple Domain?
Domain is a simple Elixir module. You can define a domain manually by creating a
new file and adding the code as shown below:

lib/tuesday/workspace.ex
defmodule Tuesday.Workspace do
use Ash.Domain
end

This is a standard Elixir module that utilizes use Ash.Domain. This macro injects
Ash Domain-related code into our module at compile time. The naming convention
of the domain module is basically AppName.DomainName.

12

Finally, edit the config.exs file and add the newly created domain under
ash_domains key. For Tuesday, the snippet from config.exs is shown below:

config/config.exs
config :tuesday,
ecto_repos: [Tuesday.Repo],
generators: [timestamp_type: :utc_datetime],
ash_domains: [
Tuesday.Audit,
Tuesday.Auth,
Tuesday.Playground,
Tuesday.Projects,
Tuesday.Workspace
]

Generating the module file can also be automated using the mix task: mix
ash.gen.domain as shown below:
$ mix ash.gen.domain Tuesday.Workspace

This also takes care of updating the config.exs file in addition to defining the
domain module.

2.5. How do I define a resource in Ash?
Defining a resource begins with creating an Elixir module. The Tuesday project
includes several pre-defined Ash Domains and Resources for you to explore. Let’s
examine what it takes to manually create, for example, the Organization Resource.
When naming modules, it’s important to follow a common naming convention for
resources: App.Domain.Resource. In our case, this is
Tuesday.Workspace.Organization. Create a new file at
lib/tuesday/workspace/organization.ex and add the following code:

13

lib/tuesday/workspace/organization.ex
defmodule Tuesday.Workspace.Organization do
use Ash.Resource,
domain: Tuesday.Workspace,
data_layer: AshPostgres.DataLayer
postgres do
table "organizations"
repo Tuesday.Repo
end
end

Adding the use Ash.Resource macro in our module is what makes our module an
Ash Resource. As you can see we’ve provided two options to the macro. The first
one being domain, we tell the resource that it is part of the domain
Tuesday.Workspace. With the data_layer option, we refer to a module that is
responsible for storing, retrieving and deleting the data represented by this
resource.
Out of the box, Ash supports two data layers: ETS (Erlang Term Storage) and
Mnesia. Ash does not recommend using the ETS data layer in production, as it
operates in-memory and data is lost when the application restarts. Similarly, Ash
advises limiting the Mnesia data layer to light usage, as it is not optimized for heavy
workloads.
Ash provides a Postgres data layer which needs to be installed as a separate
dependency. Tuesday is already configured with this dependency. Throughout this
book, we will be using AshPostgres.DataLayer which connects with a Postgres
database.
At this point, we have defined a resource, but it’s largely ineffective because we
haven’t yet added attributes, relationships, or other resource-related information. If
you examine Tuesday’s resource files, you’ll notice they are more complex than the
example above. The rest of the book covers everything you can add to a resource
file, so don’t feel overwhelmed by the complexity of Tuesday’s actual resource files.
Alternative to creating this resource file by hand, we could also use a helpful mix

14

task utility to generate the file and populate the content automatically.
$ mix ash.gen.resource Tuesday.Workspace.Organization --extend postgres

The above mix task takes in a lot of options which can be read using its doc mix
help ash.gen.resource. We have kept the options given to the mix task to the
minimum to replicate just the basic resource file content we have shown above.

2.6. How do I decide which resources belong to which Domain? How
many domains do I need?
There is no hard-and-fast rule for determining the number of domains required, as
it depends heavily on the business context. In fact, asking how many domains are
needed may be the wrong question. Understanding the principles behind creating
domains often resolves this question naturally.
The primary purpose of a domain is to enhance code maintenance, share common
policies, and expose public APIs for the rest of the application. If the business
problem domain is small, consolidating everything into a single domain can be
effective. For larger domains, break them into as many smaller, logical modules as
necessary to ensure long-term code maintainability.
For Tuesday, we have divided the application into four distinct domains, grouping
resources under each. Below is our rationale for this structure. Not everyone may
agree with this rationale, as these decisions are subjective at a certain level, guided
by broader principles. Our explanation of how we organized Tuesday’s domains
and resources can serve as an example to help you make informed decisions for
your own projects.

2.6.1. Group by Functional Responsibility:
Place resources in the same domain if they contribute to a specific functional area
or workflow of the application. This ensures that resources with similar purposes
are managed together, simplifying configuration and usage.
Example: The Tuesday.Projects domain includes Project,
ProjectMembership, Task, TaskAssignee, and Comment because they all support

15

the project management workflow, handling tasks, memberships, and discussions.
Similarly, Tuesday.Auth contains only the User resource, as it focuses exclusively
on authentication-related functionality.

2.6.2. Consider Resource Interactions and Dependencies:
Resources that frequently interact or depend on each other through relationships
(e.g., has_many, belongs_to) often belong in the same domain to streamline their
management and querying.
Example: In Tuesday.Workspace, Organization and OrganizationMember are
grouped because OrganizationMember directly depends on Organization (via
belongs_to :organization) to define team membership.

lib/workspace/organization_member.ex
defmodule Tuesday.Workspace.OrganizationMember do
...
relationships do
# Relationship in another domain
belongs_to :user, Tuesday.Auth.User do
allow_nil? false
end
# Relationship in the same domain
belongs_to :organization, Tuesday.Workspace.Organization do
allow_nil? false
end
end
end

However, separate resources into different domains if they address unrelated
concerns even if they are loosely related. This maintains clarity and prevents
domains from becoming overly complex. The User resource is in Tuesday.Auth,
not Tuesday.Workspace, despite being referenced by OrganizationMember.
Example: The User resource handles authentication (storing a unique email), a
distinct functional responsibility. Its placement in a dedicated Auth domain isolates
authentication logic, allowing specific configurations (e.g., authentication policies)

16

and future expansion (e.g., UserToken) without impacting other domains.
The belongs_to :user relationship in OrganizationMember links to User in
Tuesday.Auth, showing that User belongs to a separate domain due to its distinct
authentication focus.

Common Pitfalls to Avoid
Overloading Domains:
Don’t group unrelated resources in one domain (e.g., adding Billing
to Tuesday.Projects) just because they share a relationship. Create a
new domain for distinct concerns.
Ignoring Dependencies:
Keep

resources

with

tight

dependencies

(e.g.,

Task

and

TaskAssignee) in the same domain unless a clear functional
boundary exists.

2.7. Summary
The chapter introduced Ash, a declarative Elixir framework for backend
development, focusing on domain modeling through Ash Domains and Resources,
using the Tuesday application as an example. Below are the key concepts covered.

2.7.1. Key Concepts
• Domain Modeling: Domain modeling creates a conceptual representation of
business entities, relationships, and rules, focusing on the problem domain
(e.g., project management for Tuesday) rather than technical details (e.g., HTTP,
database transactions). Ash’s tagline, “Model the domain, derive the rest,”
emphasizes building maintainable, business-aligned software by abstracting
common patterns.
• Ash’s Role in Business Logic: Ash provides a resource-oriented framework for
domain modeling, integrating with Ecto (via AshPostgres) or other data
layers, filling the gap left by Phoenix Contexts.

17

Chapter 3. Attributes & Identities

3.1. What is a Resource Attribute?
A resource attribute is a piece of data that we want to persist in our data layer. A
simple way to understand this is to think of it as similar to a column in a database
table. In fact, for a resource using the Postgres data layer, each attribute
corresponds to a column in the table created for that resource. While it’s possible to
use an Ash Resource without a persistent data layer, this is a rare use case.

Dev Story
The Tuesday app must support storing and managing information
for multiple entities by defining attributes in their respective
resources with the data type of the value stored. Each of these
resources have different requirements on the attributes. For eg.,
Organization resource needs
1. :name (string, required) for the organization’s name.
2. :plan_type (string or atom, required) for the subscription
plan (e.g., "basic," "premium").
Task resource needs
1. :title (string, required) for the task’s name.
2. :due_date (date, optional) for the task’s deadline.
OrganizationMember resource needs
1. :role (string or atom, required) for the member’s role (e.g.,
"admin," "editor").
2. :username
identifier.

18

(string,

required)

for

the

member’s

unique

For the rest of this chapter, we will explore various questions to guide us in
defining attributes for Tuesday’s resources, each with different requirements.

3.2. How do I define attributes?
In our resource file, we start off by writing an attributes block. Inside the
attributes block, we begin defining our attribute as shown below:
attributes do
attribute name, type
end

In the case of Tuesday, for the Task resource, the name of the attribute is :title
and it is of type :string. So we define the attribute as shown below:

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects.Task do
...
attributes do
attribute :title, :string
...
end
end

Ash supports several data types by default. We can choose from any of these builtin types. Just to provide another example, if we want to define an attribute for
due_date for Task, we could do so like below:

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects.Task do
...
attributes do
attribute :title, :string
attribute :due_date, :date
...
end
end

19

Invitation to Explore Tuesday
We invite you to open up Tuesday’s codebase and go through all the
resource files under different domains. Pay attention only to the
attributes block for now. Do not get overwhelmed with other
details on the file. You will see many variations of attribute
macro which we saw now. You will learn what these variations do
and how they work in the rest of this chapter.
In Tuesday, you may find that many attribute definitions are followed by a do-end
block. The contents inside the do-end block are options to the attribute. One very
common option that you can find in various resources within our project is
allow_nil? being set to false like below:

lib/tuesday/workspace/project.ex
attribute :name, :string do
allow_nil? false
end

This simple option passed to our attribute ensures that we do not allow accidental
creation of record with empty value for :name attribute.

3.3. How do I create database columns based on my attribute config?
Defining attributes in an Ash resource module specifies the structure of our data,
but it does not automatically create or update the corresponding database table. An
Ash resource is backed by a data layer (e.g., PostgreSQL in our case), which is
separate from the resource itself. To reflect changes made to our resource’s
attribute configuration in the database, we must update the data layer. Fortunately,
Ash provides convenient Mix tasks to generate and apply migration files that
synchronize our database schema with our resource definitions.

3.3.1. Steps to Update the Database
Generate Migration Files

20

Use the ash.codegen Mix task to create migration files based on your resource’s
attribute configuration.
mix ash.codegen any_meaningful_migration_file_name_in_snake_case

Ash analyzes our resource (e.g., Tuesday.Projects.Task) and generates
migration files to create or modify tables, adding columns for each attribute as
defined.
Apply Migrations
Run the ash.migrate Mix task to execute the generated migrations and update the
database schema.
mix ash.migrate

DO THIS
Tuesday already has all the migrations files generated. So if we
want to try the above code, we need to remove all the migration
files previously generated and also drop the database. Since we are
doing this in development environment for our testing, it’s fine to
do the following:
Remove the migration files
$ rm -rf priv/repo/migrations
$ rm -rf priv/resource_snapshots
Drop the db
$ mix ash.drop
Now generate the migration files for all Tuesday’s resources
$ mix ash.codegen create_tables

21

Finally run the migration to create the actual DB tables
$ mix ash.migrate
With ash.codegen generating the migration files for all resources in Tuesday, you
can now inspect the generated migration files in priv/repo/migrations. These
are migration files that we would normally write by hand when using Ecto. Ash
automatically generates it for us.

3.4. How do I name an attribute different from db column name?
By default, Ash assumes that attribute names in a resource match the
corresponding database column names. However, there are cases where we may
want the resource attribute name to differ from the database column name. Ash
supports this scenario seamlessly by allowing us to specify a custom column name
using the source option in the attribute macro.
To map a resource attribute to a different database column name, include the
source option in the attribute definition, specifying the column name as it appears
in the database.
Consider the Tuesday.Projects.Task resource. To define an attribute named
is_complete that corresponds to a database column named is_done, use:

lib/tuesday/assignments/task.ex
attribute :is_complete, :boolean do
source :is_done
end

This configuration ensures the resource uses is_complete in our application code
(e.g., queries, changesets), while the database stores and retrieves the value from
the is_done column.

Use Case
The source option is ideal for aligning with existing legacy

22

database schemas or naming conventions differing from Elixir
conventions.
There are also various other options available which you can find in Ash docs. We’ll
learn some of these options in the subsequent topics of this chapter.

3.5. How is Ash related to Ecto.Schema?
Ash uses Ecto.Schema under the hood and creates Ecto schemas internally for all
defined Ash Resources. This essentially makes all Ash Resources an Ecto Schema as
well.
For example, defining an Ash Resource like below
defmodule Post do
use Ash.Resource
attributes do
attribute :title, :string
end
aggregates do
aggregate :comment_count, :comments
end
end

is same as creating an Ecto Schema like the one below.
defmodule Post do
use Ecto.Schema
schema "posts" do
field :title, :string
field :comment_count, :integer, virtual: true
end
end

23

As we can see, all attribute definitions map to real fields in the schema layer,
which are supported by columns in the underlying database table for that resource.
However, aggregate definitions in Ash are mapped to virtual fields in the Ecto
schema layer, as there are no corresponding columns for these data points in the
underlying database table. Ash handles calculations similarly, converting them
to equivalent virtual fields in the Ecto schema definition. Note that the Ecto schema
fields for aggregates and calculations do not contain the logic for retrieving the
data; the Ecto schema’s virtual fields serve only as placeholders.

Aggregate & Calculations
There are dedicated chapters to dive deeper into Aggregates and
Calculations in this book. So don’t worry if at this point these sound
unfamiliar. It’s enough if you understand that all Ash Resources are
Ecto Schema and that the fields in Ash Resource map to Ecto
Schema fields, either real or virtual.

3.5.1. Using Ecto Directly
For developers who have used Ecto before adopting Ash, this provides familiarity
and confidence that if we struggle to find an Ash-specific approach for our project,
we can rely on our existing Ecto knowledge until we discover a better way to
implement it in Ash. This ensures our projects avoid delays due to transitioning to
Ash. Ultimately, we will also recognize how much code Ash simplifies.

3.5.2. Does Ash simply convert into Ecto? or does it do more?
It definitely does more. Let’s not let the above explanation of how an Ash Resource
maps to an Ecto Schema lead us to assume that Ash merely converts our code into
an Ecto Schema at compile time. No, Ash is not like TypeScript, which converts to
JavaScript during compilation. It performs significant heavy lifting. This entire
book is dedicated to exploring that. For now, consider defining an Ecto Schema as
just one of the many tasks Ash accomplishes.

3.6. How do I set a primary key for a resource in Ash?
In Tuesday, all of our resources have a UUID primary key attribute. Below is an

24

example from one such resource:
attributes do
uuid_primary_key :id
...
end

You may wonder that all the other attributes use the attribute macro but for
primary key attribute we use a new one. It is because uuid_primary_key is one of
the 5 special attribute preconfigured with Ash. As a matter of fact, Ash internally
calls the attribute function with certain options that make it an auto-generated,
immutable, primary key field with UUID type.
If we want to name our primary key to be called primary_id, then this is how we’d
write it:
uuid_primary_key :primary_id

Ash provides three special macros for setting primary keys, each tailored to a
specific type:
1. uuid_primary_key: Generates a standard UUID (version 4) as the primary key.
2. integer_primary_key: Creates an auto-incrementing integer primary key.
3. uuid_v7_primary_key: Uses a time-ordered UUID (version 7) for the primary
key.
We could configure primary key attribute using the default attribute macro
without relying on the above three special macros and that would be like below in
the case of uuid_primary_key:
attribute :id, :uuid do
public?: true
writable?: false
default: &Ash.UUID.generate/0
primary_key?: true
end

25

We will learn more about these options separately in the subsequent questions in
this

chapter.

For

now,

just

go

with

the

understanding

that

using

uuid_primary_key sets all these different options for you automatically.

Why Special Macros?
Ash is all about conveniences. As we can see above, instead of
writing seven lines of code to define a single primary key attribute,
we define it in one line. Such syntactic sugar is prevalent
throughout Ash. This is a boon for experienced developers, as it
significantly reduces code noise, but it can challenge new
developers starting with Ash, making them feel there are too many
concepts to learn.
If we ever wonder how to remember all these options, rest assured
we are not alone. Fortunately, Spark, the underlying library Ash
depends on, provides autocompletion in VS Code via the ElixirLS
language server extension, requiring no additional configuration.
Of the five special attributes, we have explored three so far. In the subsequent
topics, we will examine the remaining two. Teaser: They are used for timestamping.

3.7. How do I mark attributes that are generated at data layer?
User vs Application vs DB managed attributes
Attributes are piece of information about a resource which is stored
in a column inside a database table. However, this piece of
information can originate from different source. For a Project
resource, user submitting a form can provide the project name. This
is user submitted information.
Some information about this new project can be automatically set
at the application layer without the user having to provide such as
the datetime of creating the project. This is application generated
information.

26

Finally, some information like the primary key id integer sequence
can be set by the data layer without the user or application setting
it. These are data layer generated information.
Generally, all the attributes are set by the user or by the application as explained
above and this includes even the UUID primary key. The UUID is generated by
default

using

Ash

in

the

application

layer

using

the

function

Ash.UUID.generate/0. But, in the case of defining an integer primary key, it is
generated by the database itself as it is an auto-incrementing field. If we have a
field that is generated by the database, we need to mark it as such in Ash. In order
to mark attributes that are generated at the data layer, we use the generated?
option inside the attribute block. Let’s see an example:
attribute :attribute_name, :integer do
generated? true
end

In fact, when we use integer_primary_key macro for setting the primary key,
Ash exactly does this behind the scene:
# Define primary key using special macro
integer_primary_key :id
# Define the same primary key as above manually
attribute :id, :integer do
public?: true
writable?: false
primary_key?: true
generated?: true
end

When we use mix ash.codegen to generate migrations, Ash ensures that these
columns are configured as either serial or bigserial, depending on whether the
attribute’s type is set to integer or bigint.

27

3.8. How do I define timestamp attributes?
In a typical application, one common attribute definition for nearly all resources is
the timestamp fields that store the inserted_at and updated_at timings for a
record. We typically use two fields, :inserted_at and :updated_at, to store these
values. In the Tuesday project, all resources include these two fields. So, how do we
define them, and what options are available when defining a timestamp field? That
is exactly what we will explore now.
We previously hinted at a special macro for creating timestamp fields when
discussing the primary key field earlier. We can define timestamp attributes using
the special macros create_timestamp and update_timestamp, as shown below:
attributes do
...
create_timestamp :inserted_at
update_timestamp :updated_at
end

Both these macros take in the field name that stored the timestamp values as its
argument. In our case, we’ve named them inserted_at and updated_at.
Like with creating primary key field, we could also create timestamp fields without
using this special macros
For creating :inserted_at field, both the options below does the same job.
# Define primary key using special macro
create_timestamp :inserted_at
# Define the same primary key as above manually
attribute :inserted_at, Ash.Type.UtcDatetimeUsec do
writable? false
default &DateTime.utc_now/0
match_other_defaults? true
allow_nil? false
end

28

For creating :updated_at field, both the options below does the same job.
# Define updated_at field using special macro
update_timestamp :updated_at
# Define the updated_at field as above manually
attribute :updated_at, Ash.Type.UtcDatetimeUsec do
writable? false
default &DateTime.utc_now/0
update_default &DateTime.utc_now/0
match_other_defaults? true
allow_nil? false
end

Note the addition of update_default option when using update_timestamp
macro which configures the function to call for setting the default value on every
update to the record.

What do these attribute option do?
We have already explored several options for defining attributes,
such as primary keys or timestamp fields, including default and
match_other_defaults?, without understanding what they do
behind the scenes. Don’t be confused; we haven’t covered them yet.
In the next section, we will thoroughly address these options, as
they require detailed explanations of their own. So, if we don’t yet
understand what these options do, there’s no need to panic.
Finally, most entities need both the created and updated timestamp to be recorded.
It is such a common need that Ash does spoil us with one more helper function:
timestamp/0. We can use this timestamps wrapper function to automatically
define both these fields named as inserted_at and updated_at. The wrapper
function is just called directly inside the attributes block as below:
attributes do
...
timestamps()

29

end

3.9. How do I set default values for attributes in Ash?
Dev Story
In Tuesday, Chaaru wants sensible defaults when new task records
are created. For example, she wants to automatically have the
:is_complete of a newly created task to false and a
:start_date set to today’s date if not explicitly set by the user.
This simplifies task creation in Tuesday by not having the user to
provide inputs to all the fields and setting up some default values
for the task.
Inside our attribute block, we may use the default option in order to set a default
value of the attribute:

lib/tuesday/projects/task.ex
attribute :is_complete, :atom do
default :false
...
end

From the above code snippet, we can see that the default value for is_complete is
false. If we don’t specify a value for is_complete, Ash will set it to false.
Sometimes, we need default values that are dynamic. Setting today’s date as the
default value is a good example of such a requirement. To set a dynamic value, we
must provide a function capture that computes the dynamic value for us. Let us
show you what we mean:

lib/tuesday/projects/task.ex
attribute :start_date, :date do
default &Date.utc_today/0
...
end

30

In the code snippet from Task resource, we have this attribute called :start_date
whose default value is dynamic as we’re getting today’s date. Note the prefix &
which ensures that we are capturing the function and passing the function itself as
the value and not the return value of the function call.

Do not do this
A common pitfall is calling a function in place of the function
capture. If we do call the function, its value will only be computed
during the compile time and not on runtime on demand and will
result in being a static value whose value got frozen at compile
time. This can lead to unexpected bugs which can be frustating to
debug.
The best way to visualize this pitfall is to assume the following hypothetical code
below:
attribute :start_date, :date do
default DateTime.utc_today()
...
end

Scenario 1: Assume that we deploy this code on 2025-04-13 and create a task on the
same day
iex>

Projects.create_task(%{title: "Hello"})

{:ok,
#Tuesday.Projects.Task<
title: "Hello",
start_date: ~U[2025-04-13],
...
>}

Looks like everything is working fine. We got our start_date set to the current
day automatically as expected.
Scenario 2: The code was deployed on 2025-04-13 and create a task on the next day

31

2025-04-14
iex>

Projects.create_task(%{title: "Hello"})

{:ok,
#Tuesday.Projects.Task<
title: "Hello",
start_date: ~U[2025-04-13],
...
>}

Now what was working properly on the deployed day is not working now. We
expect our date to be 14th of April but what we get is 13th April. If we don’t relate
this date to the deployed date, then we might just wonder where does this magic
13th April come from as it’s no where present in our code.
In fact, we authors, faced this exact issue when we deployed the
app to a stage environment. This bug is never visible in the
development environment as the code is constantly being modified
and compiled. Hence the static Date.utc_today is constantly being
rerun with new values making it difficult to identify in dev
environment.
Finally, default accepts only a zero-arity function when using function capture
syntax as shown above, but we can also pass the function using the {m, f, a}
syntax which allows us to specify arguments along with the other conveniences it
provides. We should still remember that default value is processed at compile
time and any dynamic variable we depend here is processed at compile time.
attribute :start_date, :date do
default {DateTime, :utc_today, []}
...
end

3.10. What does match_other_defaults option do?
In Tuesday app, we have two modules Playground.Timestamp and

32

Playground.MatchDefault to understand both default and
match_other_default. Let’s look at it one by one.
defmodule Tuesday.Playground.Timestamp do
...
attributes do
attribute :title, :string, public?: true
attribute :inserted_at, Ash.Type.UtcDatetimeUsec do
default &DateTime.utc_now/0
match_other_defaults? true
...
end
attribute :updated_at, Ash.Type.UtcDatetimeUsec do
default &DateTime.utc_now/0
match_other_defaults? true
update_default &DateTime.utc_now/0
...
end
end
end

We will also run the following command in the iex shell of this project as it’s much
easier to understand them in action.
We are using functions from Ash.Changeset that we haven’t
covered yet. Treat them as blackboxes for now. Both for_create/2
and apply_attributes/1 together simulate inserting a record into
the database. For our purpose of understanding what default and
match_other_defaults?, this simulation is needed and it’s okay if
you don’t understand what changesets are and how they function.
We have a dedicated chapter to go in detail about Ash Changeset.

iex> Tuesday.Playground.Timestamp |> Ash.Changeset.for_create(:create,
%{title: "Hello"}) |> Ash.Changeset.apply_attributes

33

{:ok,
#Tuesday.Playground.Timestamp<
title: "Hello",
inserted_at: ~U[2025-04-13 05:01:39.390613Z],
updated_at:

~U[2025-04-13 05:01:39.390613Z],

...
>}

We are trying to create a new Timestamp record with the parameters %{title:
"Hello"}. As we can see above, we indeed get a record with the title set to "Hello,"
but we also have inserted_at and updated_at values set based on the default
value, which is DateTime.utc_now/0, providing the current date and time with
microsecond precision.
Now, pay attention to the timestamp values generated for both inserted_at and
updated_at. Notice that they are identical, down to the microsecond precision.
This is because match_other_defaults? is set to true on both of them. This
ensures that the default function defined in both of them is called only once. The
output of this function call is then used for both inserted_at and updated_at.
Let’s quickly change match_other_defaults? to false for the updated_at field.
attribute :updated_at, Ash.Type.UtcDatetimeUsec do
...
match_other_defaults? false
end

Ensure you either recompile or restart the iex shell to load the modified code.
iex> recompile()
iex> Tuesday.Playground.Timestamp |> Ash.Changeset.for_create(:create)
|> Ash.Changeset.apply_attributes
{:ok,
#Tuesday.Playground.Timestamp<
inserted_at: ~U[2025-04-13 05:03:09.793439Z],
updated_at:
...
>}

34

~U[2025-04-13 05:03:09.793378Z],

And now as we can see the updated_at field is different than the inserted_at
field. There is a slight difference at the microsecond level because Ash now calls the
default function twice. Between these two calls there is microsecond level
difference which is evident in the values generated.
As another example to explain the same match_other_defaults setting, have a
look at the Playground module MatchDefault present in Tuesday.
defmodule Tuesday.Playground.MatchDefault do
...
def random_value, do: System.unique_integer()
attributes do
uuid_primary_key :id
attribute :test_same_random1, :integer do
default &random_value/0
match_other_defaults? true
end
attribute :test_same_random2, :integer do
default &random_value/0
match_other_defaults? true
end
attribute :test_different_random, :integer do
default &random_value/0
match_other_defaults? false
end
end
end

Here

we

have

random_value/0.

three

attributes

However,

two

sharing

the

of

these

same

default

attributes

function
have

a

match_other_defaults? set to true, while the third one is set to false. As per
our explanation above, random_value/0 function must be called twice in total. The
return value from the first call should be used for the first two attributes and the
return value from the second function call should be used to set the default value

35

for the third attribute. Let’s confirm this on iex using the code snippet below:
iex> Tuesday.Playground.MatchDefault |> Ash.Changeset.for_create(
:create) |> Ash.Changeset.apply_attributes
{:ok,
#Tuesday.Playground.Timestamp<
test_same_random1: -576460752303415421, # Same
test_same_random2: -576460752303415421, # Same
test_different_random1: -576460752303415485, # Different
...
>}

3.11. How do I restrict an attribute from being written?
Dev Story
Chaaru wants to ensure that certain organization details, like a
unique slug attribute in the Organization resource remains
system-generated and cannot be manually updated. Since it’s
automatically derived from the organization’s name, allowing edits
could break consistency.
By default, the ID and timestamp attributes are restricted from being written as
they should be generated rather than given as input. Let’s take the example of the
slug attribute of organization which is generated from the name of the
organization. We first need to restrict it from being written and we can do so like
below:
attribute :slug, :string do
writable? false
end

As you can see above, we’ve used the writable? option with the value false
which restricts it from giving an input. This is the same option that all the special
attributes use behind the scenes.
But, we still need to generate the slug somewhere and it needs to be in the

36

Organization that we’re creating. For that we use force_change_attribute/3
function in Ash.Changeset.
For completeness sake we are providing the code to update a field
which is not writable. However, at this point in the book, we
haven’t covered Changeset. They appear later in the book. So don’t
worry if you don’t understand the below code yet.
So, in the create action of our organization resource, we can define a change using
anonymous function that generates the slug and sets it in the organization. Let’s see
how we can do that:

lib/tuesday/accounts/organization.ex
create :create do
change fn changeset, _ctx ->
slug =
Ash.Changeset.get_attribute(changeset, :name)
|> String.downcase
|> String.replace(~r/\s+/, "-")
Ash.Changeset.force_change_attribute(changeset, :slug, slug)
end
end

In the above code snippet, we first retrieve the organization name from the
changeset. Then, we convert it into a slug by converting it to lowercase and
replacing spaces with hyphens to create the slug. Finally, we use the
Ash.Changeset.force_change_attribute

function,

which

takes

three

arguments:
1. Changeset
2. Attribute name
3. Value
In our case, the attribute name is :slug, and its value is the contents of the slug
variable. This function sets the value of an attribute in the changeset that is not

37

allowed to be provided as input. Now, whenever we create an organization, its slug
is automatically derived from the organization name.
If you require a similar slug functionality in your app, Ash already
has a nicely packaged extension to do this: https://github.com/ashproject/ash_slug

3.12. How do I enforce constraints on attributes in Ash?
Dev Story
Chaaru wants a robust system that validates the user input against
several criteria set by the business. Tuesday has specific constraints
on some of the attributes beyond the type of the attribute. For
example, it needs to enforce rules on the values stored for Task
resource’s :priority attribute. These values should be within a
range of 1 to 5. Another rule is that OrganizationMember
resource’s :username attribute should be restricted to 3-20
characters with only certain letters.
In Ash, we set constraints using the constraints option with the value being a
keyword list. Let’s see an example:

lib/tuesday/assignments/task.ex
attribute :priority, :integer do
constraints min: 1, max: 5
...
end

So in the above code snippet, it is very easy to figure out that we’re constraining the
priority to be in the range of 1-5. In order to see what are all the keys and values
that need to go as value to constraints, we may check out the documentation for
each type of data. In our case, as our attribute is integer, we can check out the
documentation here. In the documentation, you may find that two constraints are
allowed and they are :min and :max.

38

Let’s see one more common example with an attribute of type string:

lib/tuesday/workspace/organization_member.ex
attribute :username, :string do
constraints [
min_length: 3,
max_length: 20,
match: ~r/^[a-z_-]*$/
]
end

The full list of constraints for :string type can be found at here. Out of those
constraints, we have used three constraints: min_length, max_length, and match.
While min_length and max_length are self-explanatory, we need to understand
the match constraint, which restricts an attribute’s value to a given regex pattern.
In our case, the pattern ~r/^[a-z_-]*$/ ensures that the username contains only
lowercase letters, underscores, or hyphens.
Now that you know the basics of constraints, you can check out all the constraints
that we have used in Tuesday.

3.13. How do I restrict sensitive field values from being inspected?
Dev Story
Chaaru pays special attention to data privacy. She doesn’t want any
sensitive data to be leaked. She knows software applications log
data about its user interactions for various purposes but she doesn’t
want any of the sensitive information about the user to be
accidentally captured in these logs. For eg., when logging the user
information, it is important to hide the :email attribute. This
ensures sensitive data remains secure in production environments.
For attributes that contain sensitive data that we don’t want to be inspected, we
need to set the sensitive? option to true for the attributes that we don’t want to
be inspected:

39

lib/tuesday/accounts/user.ex
attribute :email do
...
sensitive? true
end

Now, in the shell, wherever the actual email should be, it replaces it with "*\*
Redacted **".
But, within the development environment, we would want to see the actual values
rather the text "*\* Redacted **". In order to see the actual values, in our
config/dev.exs, we need to add the following line:
config :ash, show_sensitive?: true

3.14. What are identities and How do I define it?
Identities are used to enforce uniqueness of attributes in our resource. When we
define an identity, we mean that the attribute or a list of attributes as a group in the
resource should be unique. It also generates a unique key constraint in the
database.

Dev Story
Chaaru wants to ensure that no two users registered in Tuesday
share the same email address to prevent account conflicts.
The requirement is for Tuesday to enforce uniqueness on the :email attribute of
the User resource, guaranteeing that each user has a distinct identifier across the
platform. Defining identity solves this.

lib/tuesday/accounts/user.ex
defmodule Tuesday.Accounts.User do
...
identities do
identity :unique_email, :email

40

end
end

All identities of a resource are defined within the identities block. As shown in
the code snippet above, we define individual identities using the identity macro,
with the first argument being the name we assign to the identity and the second
argument being the name of the existing attribute for which we want to enforce
uniqueness. Defining an identity creates a unique key constraint in the database
when we generate the migration file next time using mix ash.codegen.
After migrating the database, we can see that we’re not able to create records with
the same email in our user resource:
# Creates user first time
iex> Ash.create(Tuesday.Auth.User, %{email: "user@example.com"},
authorize?: false)
INSERT INTO "users" ...
# Error on second time due to unique email constraint
iex> Ash.create(Tuesday.Auth.User, %{email: "user@example.com"},
authorize?: false)
[debug] QUERY ERROR source="users" db=10.7ms queue=1.8ms idle=122.8ms
{:error,
%Ash.Error.Invalid{
bread_crumbs: ["Error returned from: Tuesday.Auth.User.create"],
changeset: "#Changeset<>",
errors: [
%Ash.Error.Changes.InvalidAttribute{
field: :email,
message: "A user with the given email already exists.",
...

3.15. How do I define multi-attribute identities in Ash?
Dev Story
In Tuesday, Chaaru wants to ensure that no two tasks within the
same project share the same title to avoid confusion.

41

The requirement enforces uniqueness on the combination of :title and
:project_id attributes in the Task resource, allowing identical titles across
different projects but not within one. This involves defining a multi-attribute
identity.
In the last topic, we’ve only defined an identiy for a single attribute and that was
:email. But, we can also define an identity for multiple attributes. In this case,
we’re defining an identity for :title and project_id, meaning that both values
should be unique when combined.
defmodule Tuesday.Projects.Task do
...
identities do
identity :unique_title_per_project, [:title, :project_id] do
description "Ensures task titles are unique within a project and
tenant."
end
end
end

The description macro is very useful for writing a short
description of what an identity means to our application. Even if
something is clear to us now, it may not remain so six months later.
The

description

macro

serves

as

a

reusable

piece

of

documentation within Ash, as it is utilized even in automatically
generated code interface functions. We will explore this further in
the Code Interface chapter.

3.16. Anatomy of Attributes
An attribute in an Ash resource, defined using the attribute dsl, encapsulates all
metadata for a specific field in a struct named Ash.Resource.Attribute. This
struct, provided by Ash, stores the configuration that drives the behavior of the
field.
Attribute Struct Definition
The Ash.Resource.Attribute struct is defined as follows:

42

defmodule Ash.Resource.Attribute do
@moduledoc "Represents an attribute on a resource"
defstruct [
:name,
:type,
:allow_nil?,
:generated?,
:primary_key?,
:public?,
:writable?,
:always_select?,
:select_by_default?,
:default,
:update_default,
:description,
:source,
match_other_defaults?: false,
sensitive?: false,
filterable?: true,
sortable?: true,
constraints: []
]
...
end

The attribute macro populates the Ash.Resource.Attribute struct with values
based

on

your

DSL

configuration

(e.g.,

attribute

:title,

:string,

allow_nil?: false). We can retrieve these data about all the attributes using
helper functions defined in Ash.Resource.Info module.

Declarative Nature of Ash
A recurring theme in this book is that Ash is a declarative
framework.

Developers

specify

what

they

want

through

configurations like attributes and Ash handles the how internally,
processing these declarations to deliver the desired behavior. This
eliminates the need for imperative code, allowing you to focus on
defining your application’s requirements.

43

3.17. Summary
The chapter covered core concepts of defining and managing attributes and
identities, as demonstrated through the Tuesday application. Below are the key
concepts explored.

3.17.1. Key Concepts
• Resource Attributes: Attributes represent persistent data in an Ash resource,
typically mapping to database columns in a data layer like PostgreSQL. They
are defined in an attributes block using the attribute macro, specifying the
name and type (e.g., attribute :title, :string for a Task resource).
• Attribute Options: Attributes support options like allow_nil? false to
enforce non-null values, default for setting static or dynamic defaults (e.g.,
default

&Date.utc_today/0), and constraints for validation (e.g.,

constraints min: 1, max: 5 for an integer).
• Special Attribute Macros: Ash provides macros for common fields, including
uuid_primary_key

:id

for

UUID

primary

keys,

create_timestamp

:inserted_at and update_timestamp :updated_at for timestamp fields,
and timestamps() to define both timestamps at once.
• Database Synchronization: Attributes require database schema updates via
mix ash.codegen to generate migration files and mix ash.migrate to apply
them, ensuring the data layer reflects resource definitions.
• Identities: Identities enforce uniqueness on single or multiple attributes (e.g.,
identity

:unique_email,

:email for a User resource or identity

:unique_title_per_project,

[:title,

:project_id]

resource), creating unique key constraints in the database.

44

for

a

Task

Chapter 4. Ash.Query
Ash.Query provides a set of APIs to interact with the data represented by all the
resources defined in our application. Regardless of which DataLayer our resources
use, Ash.Query offers a unified way to work with this underlying data. For
example, in the Tuesday app, we have a Task resource with a PostgreSQL data
layer. Ash.Query provides APIs to interact with this task data, such as retrieving all
tasks in the table or applying filters, like tasks from a specific project. We will use
Tuesday’s seed data throughout this chapter to understand how to use Ash.Query
for various needs.
This chapter serves as a quick introduction to Ash.Query. We will cover all the
essential functions related to querying data without delving into joins, aggregates,
or calculations. These omitted aspects of Ash.Query will be addressed later in the
book after we explore these concepts in more detail.
Ash is designed to deliver an exceptional developer experience! At
first glance, the Ash.Query code in this chapter might seem similar
to Ecto queries or appear verbose, leading us to question how Ash
helps us write concise code if we need to craft these queries
manually.
In reality, we rarely write Ash.Query code by hand in most
applications. The upcoming chapters on Ash Actions introduce
powerful abstractions and syntactic sugar that simplify query
construction significantly. We have included this chapter before
diving into Ash Actions to build a solid understanding of the
foundational Ash.Query APIs, which power the functionality of Ash
Read Actions.
By the end of this chapter, we will have a good understanding of the core
functionalities of Ash.Query, organized into four major categories:

45

Query Construction
We will discover how to initialize and build queries from scratch using
functions like build/3 and new/2, apply filters with filter/2 and
filter_input/2, and ensure unique results with distinct/2, enabling us to
define the foundational structure of our queries.
Field Selection
We will gain expertise in managing which fields appear in query results using
select/3, ensure_selected/2, deselect/2, and selecting?/2, giving us
fine-grained control over the data returned.
Sorting
We will master sorting query results using functions such as sort/3,
sort_input/3, and default_sort/3 for fallback sorting.
Limit and Offset
We will learn how to paginate query results with the limit/2 and offset/2
functions.
To follow along, you can ensure that you are on the main branch of
Tuesday app and you have run mix ecto.reset. This drops the
database and recreates it with all the seed data we have configured
already in the app for you. If you have dropped the database as part
of any other exercise in this book and just ran mix ash.reset, you
do not have the seeds data inserted in the DB and all the following
queries will result in empty lists.

Query Construction
4.1. How to create a simple query?
To start with, let’s try creating an Ash.Query equivalent to the following SQL
SELECT * from tasks;

46

An equivalent of the above in Ash.Query is
iex> Ash.Query.new(Task)
#Ash.Query<resource: Tuesday.Projects.Task

The above result is an Ash.Query struct that contains multiple fields to store
various query requests. Since our query is a simple selection from a table without
additional filters, Ash hides irrelevant empty fields to display only the relevant
portion.
We will reveal these hidden fields, just for this instance alone, to briefly examine
their contents. As we proceed, we will use the simplified format shown above.
iex> Ash.Query.new(Task) |> IO.inspect(structs: false)
%{
action_failed?: false,
sort: [],
context: %{},
page: nil,
around_transaction: [],
invalid_keys: %{map: %{}, __struct__: MapSet},
after_action: [],
load: [],
load_through: %{},
limit: nil,
__validated_for_action__: nil,
timeout: nil,
phase: :preparing,
sort_input_indices: [],
params: %{},
action: nil,
calculations: %{},
offset: 0,
authorize_results: [],
resource: Tuesday.Projects.Task,
domain: nil,
lock: nil,
select: nil,
distinct: nil,
__struct__: Ash.Query,

47

aggregates: %{},
arguments: %{},
tenant: nil,
distinct_sort: [],
before_action: [],
to_tenant: nil,
filter: nil,
errors: [],
valid?: true
}
#Ash.Query<resource: Tuesday.Projects.Task>

As we can see from the entire %Ash.Query{} struct, the only field with a value set
is the resource key. This struct stores sufficient information for Ash to generate
the corresponding SQL. In this case, Ash only needs to know from which resource’s
data layer to query the data. We have provided Tuesday.Projects.Task, and the
resource is already configured with details about its data layer and the table that
stores the data. Using all the related data, Ash.Query can produce the SQL when
requested. We can try this manually for our learning.

4.2. How do I filter data?
Retrieving all data via a select query is the least engaging, and in real life, we apply
many conditions to meet when fetching data. For example, if we want to retrieve all
tasks with a completed status, we would write the following SQL:
SELECT * FROM tasks WHERE is_done = true;

In Ash.Query, the equivalent is:
# We are using `Ash.Query.filter` which is a macro
# Hence, we need to `require Ash.Query` before using it.
iex> require Ash.Query
iex> Ash.Query.new(Task) |> Ash.Query.filter(is_complete: true)
#Ash.Query<resource: Tuesday.Projects.Task,
filter: #Ash.Filter<is_complete == true>>

48

The filter key in the resulting Ash.Query stores the filter information we have
provided. In this case, it is #Ash.Filter<is_complete == true>>.
In SQL, under the WHERE clause, the field used for filtering is is_done, whereas in
Ash.Query, we have used the attribute name is_complete for performing the
equivalent filtering.
This is because when we defined the attribute is_complete for Task, we used the
source attribute to link the actual column name is_done as per the data layer,
since the attribute name does not match the source column name. Hence the
difference here. For reference, this is how Task resource defines its is_complete
attribute:

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects.Task do
attributes do
attribute :is_complete, :boolean do
source :is_done
default false
allow_nil? false
end
end
end

Within Ash.Query, we only use the attribute names and Ash handles translating
them to the appropriate column names behind the scenes!
Let us refocus our attention on the Ash.Query.filter code above, which results
in an additional filter key set in our Ash.Query struct. We can also chain
multiple filters, and Ash will combine these filters with each chaining.
iex> Ash.Query.new(Task) |> Ash.Query.filter(is_complete: true) |>
Ash.Query.filter(title: "Hello World")
#Ash.Query<resource: Tuesday.Projects.Task,
filter: #Ash.Filter<is_complete == true and title == "Hello World">>

4.3. What’s the difference between filter and filter_input?

49

Ash.Query.filter is a macro, and Ash.Query.filter_input is an Elixir
function. The filter macro is intended for creating queries from developer input,
which is always trusted. Ash does not sanitize the input given to the filter macro
and allows potentially unsafe operations because the developer adding these filters
is trusted. On the other hand, filter_input is useful for filtering based on user
input in the application, such as in a UI, which requires sanitization.
To understand this, let’s filter on a non-public attribute using both filter and
filter_input
iex> Ash.Query.new(Task) |> Ash.Query.filter(%{"title" => "Hello",
"is_complete" => false})

The is_complete attribute is defined as a private field in Tuesday.Project.Task
and still filter macro accepts the input for it.
iex> Ash.Query.new(Task) |> Ash.Query.filter_input(%{"title" => "Hello",
"is_complete" => false})
#Ash.Query<
resource: Tuesday.Projects.Task,
errors: [
%Ash.Error.Query.NoSuchField{
resource: Tuesday.Projects.Task,
field: "is_complete",
splode: Ash.Error,
bread_crumbs: [],
vars: [],
path: [:filter],
stacktrace: #Splode.Stacktrace<>,
class: :invalid
}
]
>

Because is_complete is a private field, filter_input functions returns with an
error that the field is_complete doesn’t exists.
We must always use filter_input for user-facing input to avoid

50

security issues.
For complex filters like checking if the title field contains a specific string in it,
we can use Ash.Expr.expr/1 macro.
iex> import Ash.Expr
iex> (Ash.Query.new(Task)
|> Ash.Query.filter_input(expr(contains(title, "Task 1"))))
#Ash.Query<
resource: Tuesday.Projects.Task,
filter: #Ash.Filter<contains(title, "Task 1")>
>

4.4. Why don’t we see the resultant data when using Ash.Query?
So far, we have written the SQL equivalent in Ash.Query, but it has not been
executed to retrieve the data. This is an important point to remember. Ash.Query
does not execute any commands in the data layer. It only collects all the
information related to fetching data in a convenient struct. It is merely a plan that
has not yet been executed. When we have finished collecting the query
requirements, we can pass the Ash.Query struct to Ash.read! to execute the
request in the data layer and retrieve the data.
iex> Ash.Query.new(Task) |> Ash.read!(authorize?: false)
[debug] # Cleaned up SQL
SELECT id, description, title, inserted_at, is_done, project_id,
parent_task_id, start_date, due_date, story_point, updated_at,
creator_id FROM tasks;
[
#Tuesday.Projects.Task<
... # Truncated...

The actual SQL command that was run above is replicated below in a cleaned-up
form for easy reading.

51

SELECT
id,
description,
title,
inserted_at,
is_done,
project_id,
parent_task_id,
start_date,
due_date,
story_point,
updated_at,
creator_id
FROM tasks;

If we have been reading the source code for the Task resource, we might notice
that the Task resource contains a priority attribute that is not selected in the SQL.
We will learn about this in the next section.
Going forward, we will show the cleaned up version of the SQL in
IEx shell for easy understanding instead of the Ecto generated
query with different aliases and placeholders that is hard to read
immediately.

Field Selection
When fetching data, we often want to specify exactly which fields (attributes) we
need in the results to optimize performance or simplify our data structure. The
Field

Selection

functions

in

Ash.Query—select/3,

ensure_selected/2,

deselect/2, and selecting?/2—provide precise control over the fields returned
by our queries.
In this section, we will explore how to select specific fields, ensure certain fields are
included, remove unwanted fields, and check if fields are selected.

52

4.5. How do I select only a specific field?
Supposing we do not want all fields from the tasks table in the query output but
only the id and title fields, we would write an SQL query like the one below:
SELECT id, title from tasks;

An equivalent of the same in Ash.Query would be
iex> (Ash.Query.new(Task)
|> Ash.Query.select([:id, :title])
|> Ash.read!(authorize?: false))
[debug] # Cleaned up SQL
SELECT id, title, story_point FROM tasks
[
#Tuesday.Projects.Task<
id: "0542c8d0-fcc7-4c37-9f32-8d307409432e",
title: "Task 0",
description: #Ash.NotLoaded<:attribute>,
is_complete: #Ash.NotLoaded<:attribute>,
priority: #Ash.NotLoaded<:attribute>,
...

with the new select option in our Ash.Query, Ash only selects the specified fields,
marking the other fields as #Ash.NotLoaded<:attribute, field: …>. You
might notice that it also selects story_point which we haven’t selected. This is
because in the Task resource, story_point attribute is configured with
always_select? true which makes this field always available in our query even
if we didn’t select it explictly.
attribute :story_point, :integer do
constraints min: 1, max: 21
default 3
allow_nil? false
always_select? true
end

53

4.6. Ensuring Fields Are Included with ensure_selected/2
Sometimes, we want to add fields to the selection without overwriting existing
selections. The ensure_selected/2 function ensures specific fields are included
while preserving the default selected fields or previously selected fields. To explain
this, we have configured the Task resource attribute priority as shown below:

lib/tuesday/projects/task.ex
attribute :priority, :integer do
...
select_by_default? false
end

The attribute configuration select_by_default? false removes this field from
database

query

by

default.

Run

Ash.Query.new(Task)

|>

Ash.read!(authorize?: false) to confirm that the returned task record doesn’t
load the priority field:
iex> Ash.Query.new(Task) |> Ash.read!(authorize?: false)
...
#Tuesday.Projects.Task<
priority: #Ash.NotLoaded<:attribute, field: :priority>,
...
>

If we used select/3 now to select the missing priority field, it would replace the
default selection of other fields and would only show priority and every other
field would be not loaded.
iex> (Ash.Query.new(Task)
|> Ash.Query.select([:priority])
|> Ash.read!(authorize?: false))
# Results will include `:priority` field but will miss the other fields
which were loaded earlier

If we use ensure_selected, it respects the previous selection by default and

54

additionally adds priority field as we can see below:
iex> (Ash.Query.new(Task)
|> Ash.Query.ensure_selected([:priority])
|> Ash.read!(authorize?: false))
# Results will include `:priority` without removing the previously
available default fields

4.7. Removing Fields with deselect/2
If we’ve selected fields but later decide some are unnecessary, the deselect/2
function lets us remove them from the selection. For example, suppose we selected
title and priority but want to exclude priority later on.
iex> (Ash.Query.new(Task)
|> Ash.Query.select([:title, :priority])
|> Ash.Query.deselect([:priority]))
#Ash.Query<resource: Tuesday.Projects.Task, select: [:id, :title,
:story_point]>

The deselect/2 function removes the specified fields from the select field,
leaving the remaining ones. This is useful for fine-tuning queries.

4.8. Checking Field Selection with selecting?/2
To verify whether a specific field is included in the query’s selection, we can use the
selecting?/2 function. This returns true if the field is selected and false
otherwise. For example:
iex> query = Ash.Query.new(Task) |> Ash.Query.select([:title,
:due_date])
iex> Ash.Query.selecting?(query, :title)
true
iex> Ash.Query.selecting?(query, :priority)
false

55

This function is helpful when debugging or dynamically adjusting queries based on
their current state. It checks the select field in the %Ash.Query{} struct without
executing the query.

Sorting
4.9. Sorting Data with sort/3
Let’s begin with a simple sorting example equivalent to the following SQL query,
which orders tasks by their title in ascending order:
SELECT * FROM tasks ORDER BY title ASC;

In Ash.Query, we achieve this with the sort/3 function:
iex> Ash.Query.new(Task) |> Ash.Query.sort(:title)
#Ash.Query<resource: Tuesday.Projects.Task, sort: [title: :asc]>

The sort/3 function adds a sorting instruction to the %Ash.Query{} struct, stored
in the sort field. Here, sort: [title: :asc] tells Ash to order results by the
title attribute in ascending order. By default, sorting is ascending (:asc), so we
can omit the direction for brevity.
We can sort by multiple fields, combining different directions (ascending and
descending). For example, to sort tasks by priority descending (highest first) and
then by title ascending:
SELECT * FROM tasks ORDER BY priority DESC, title ASC;

In Ash.Query:
iex> Ash.Query.new(Task) |> Ash.Query.sort(priority: :desc, title: :asc)
#Ash.Query<resource: Tuesday.Projects.Task, sort: [priority: :desc,
title: :asc]>

This chains the sorting conditions, ensuring tasks with higher priority appear first,

56

and within the same priority, titles are sorted alphabetically.

4.10. Handling User-Provided Sorting with sort_input/3
In some cases, we need to sort based on user input, such as when a user selects a
sort option in a UI (Example: “Sort by title” or “Sort by priority descending”). The
sort_input/3 function is designed for this, accepting sort instructions from
external sources like API requests.
Consider a user requesting tasks sorted by title descending, equivalent to:
SELECT * FROM tasks ORDER BY title DESC;

If the user input is a string like "-title" (where - means descending), we can use
sort_input/3:
iex> Ash.Query.new(Task) |> Ash.Query.sort_input("-title")
#Ash.Query<resource: Tuesday.Projects.Task, sort: [title: :desc]>

sort_input/3 supports string-based inputs with prefixes:
• +title or title: Ascending (:asc).
• ++title: Ascending with nulls first (:asc_nils_first).
• -title: Descending (:desc).
• --title: Descending with nulls last (:desc_nils_last).
We can also pass a comma-separated string for multiple sorts, like sorting by
due_date descending and title ascending.
iex> Ash.Query.new(Task) |> Ash.Query.sort_input("-due_date,title")
#Ash.Query<resource: Tuesday.Projects.Task, sort: [due_date: :desc,
title: :asc]>

sort_input also takes care of sanitizing the input and adding error for fields
which are not allowed for user sorting. As we saw earlier priority field is not

57

public. So while sort allowed sorting using the priority field, sort_input will
reject it with an error.
iex> Ash.Query.new(Task) |> Ash.Query.sort_input("-priority,title")
#Ash.Query<
resource: Tuesday.Projects.Task,
errors: [
%Ash.Error.Query.NoSuchField{
resource: Tuesday.Projects.Task,
field: "priority",
splode: Ash.Error,
bread_crumbs: [],
vars: [],
path: [:sort],
stacktrace: #Splode.Stacktrace<>,
class: :invalid
}
]
>

This makes sort_input/3 ideal for user-driven sorting scenarios where we want
to ensure that users don’t provide inputs where it is not allowed for them.

Limit and Offset
4.11. Limiting Results with limit/2
Let’s start with a simple example where we want to fetch only a max of 5 tasks from
our dataset, equivalent to the following SQL query:
SELECT * FROM tasks ORDER BY inserted_at ASC LIMIT 5;

In Ash.Query, we achieve this with the limit/2 function:
iex> (Ash.Query.new(Task)
|> Ash.Query.sort(:inserted_at)
|> Ash.Query.limit(5))
#Ash.Query<resource: Tuesday.Projects.Task, sort: [inserted_at: :asc],

58

limit: 5>

The limit/2 function sets the limit field in the %Ash.Query{} struct, specifying
the maximum number of records to return. Here, limit: 5 instructs Ash to fetch
no more than five tasks. This is useful when we want to display a small batch of
results. We have added sort because using pagination with offset and limit
without an explicit sort can lead to unpredictable results, as the database may
apply different sort orders for various reasons.

4.12. Skipping Results with offset/2
Often, we need to skip some records before fetching a batch, such as when
navigating to the second page of results. The offset/2 function lets us specify how
many records to skip, working hand-in-hand with limit/2. For example, to fetch 5
tasks starting after the first 10 (example, the third page if each page has 5 tasks), we
use a SQL query like:
SELECT * FROM tasks ORDER BY inserted_at LIMIT 5 OFFSET 10;

In Ash.Query:
iex> (Ash.Query.new(Task)
|> Ash.Query.sort(:inserted_at)
|> Ash.Query.limit(5)
|> Ash.Query.offset(10))
#Ash.Query<resource: Tuesday.Projects.Task, sort: [inserted_at: :asc],
limit: 5, offset: 10>

The offset/2 function sets the offset field in the %Ash.Query{} struct. Here,
offset: 10 skips the first 10 tasks, and limit: 5 ensures we get the next 5. This
combination is the foundation of offset-based pagination, commonly used in web
applications with page number based pagination.
The limit and offset values must be non-negative integers. If we set invalid limit
(like limit: -1), Ash will set the limit to 0 and invalid offset value (like offset:
-10), Ash will ignore the offset.

59

Offset-based pagination can be slow for large datasets (for example,
high offsets like 10,000), as the database must scan all skipped rows.
For better performance with large data, we can explore keyset
pagination using Ash’s page/2 function, which we will cover in the
Ash Action chapter.

Ash.Query and Ecto.Query
4.13. What is the difference between Ash Query and Ecto Query?
If we are familiar with Ecto, we can already spot many similarities with the
Ecto.Query API provided by the Ecto library. While there are many similarities,
Ash.Query provides numerous conveniences that are not available in Ecto.Query.
We will cover these as we progress, but for now, there is one aha moment worth
mentioning.
Ash.Query is actually a layer of abstraction over Ecto.Query. To understand what
we mean by that, we can run the following code:
iex> Ash.Query.new(Task) |> Ash.Query.data_layer_query
{:ok,
#Ecto.Query<from t0 in Tuesday.Projects.Task, as: 0,
select: struct(t0, [
:id,
:priority,
:status,
:description,
:title,
:due_date,
:inserted_at,
:parent_task_id,
:project_id,
:start_date,
:updated_at
])>}

As we can see, the resulting tuple is actually an Ecto.Query. Behind the mask of

60

Ash.Query, we always, always, always deal only with Ecto.Query for Postgresql
Datalayer. (We apologize for the repetition, but we want to ensure this important
point is not missed :-))
When we, authors, started working with Ash, this fact gave us a lot of confidence
because, even if we struggle to accomplish tasks using the Ash approach at a critical
juncture, we can always fall back to our familiar method of using Ecto.Query. We
will cover this as well in the subsequent sections.

4.14. What are Ash.Query escape hatches?
Because libraries like Ecto and Ash provide an easy abstraction over a complex set
of SQL operations, there can be rare situations where our needs are not met by the
abstraction layer. Hence, we may need to directly access the underlying SQL layer
to obtain the data we need. In such cases, escape hatches are useful.
Ecto comes standard with two forms of escape hatch:
Ecto.Query.API.fragment/1 and Ecto.Adapters.SQL.query/4, if we use the
ecto_sql Elixir library in our project.
We have already seen that Ash.Query is an abstraction layer for Ecto.Query.
We have also seen that defining an Ash Resource creates an Ecto Schema, which
makes our Task module, defined as an Ash Resource, also an Ecto Schema. Now we
have all the pieces in place to start using Ecto as if Ash does not exist.
iex> require Ecto.Query
iex> Task |> Ecto.Query.where(is_complete: true) |> Tuesday.Repo.all
[debug] # Cleaned up query given below:
SELECT id, title, description, is_done, priority, story_point,
start_date, due_date, inserted_at, updated_at, project_id, creator_id,
parent_task_id FROM tasks WHERE is_done = TRUE;

Knowing that this escape hatch exists gave us confidence when we started using
Ash.Query, but in reality, we never needed to use this hatch, as Ash.Query
covered virtually all use cases for our needs!

61

4.15. Putting It All Together with Ash.Query.build
The following code puts everything that we have learned in this chapter so far.
# Because `Ash.Query.filter` is a macro, we require `Ash.Query`
iex> require Ash.Query
iex> import Ash.Expr
iex> (query = Ash.Query.new(Task)
|> Ash.Query.filter(is_complete: true)
|> Ash.Query.filter_input(expr(contains(title, "Task 1")))
|> Ash.Query.sort(priority: :desc)
|> Ash.Query.sort_input("-due_date")
|> Ash.Query.select([:title, :due_date, :priority])
|> Ash.Query.ensure_selected([:priority])
|> Ash.Query.deselect([:is_complete])
|> Ash.Query.limit(10)
|> Ash.Query.offset(20))
#Ash.Query<
resource: Tuesday.Projects.Task,
filter: #Ash.Filter<is_complete == true and contains(title, "Task
1")>,
sort: [priority: :desc, due_date: :desc],
limit: 10,
offset: 20,
select: [:id, :priority, :title, :due_date, :story_point]
>
iex> Ash.Query.selecting?(query, :priority)
true
iex> query |> Ash.read!(authorize?: false)
[debug] # Cleaned up query given below:
SELECT id, priority, title, due_date, story_point FROM tasks WHERE
is_done = true AND title LIKE '%Task 1%' ORDER BY priority DESC,
due_date DESC LIMIT 10 OFFSET 20;
[
#Tuesday.Projects.Task<title: "Task 101", due_date: ~D[2025-04-20],
status: "completed", ...>,
...
]

62

If we want to build this entire query but with a single function call, then
Ash.Query.build/3 comes to rescue.
iex>

query_opts = [
filter: [is_complete: true],
filter_input: expr(contains(title, "Task 1")),
sort: [priority: :desc],
sort_input: "-due_date",
select: [:title, :due_date, :priority],
ensure_selected: [:priority],
deselect: [:is_complete],
limit: 10,
offset: 20
]

iex>

Ash.Query.build(Task, query_opts)

#Ash.Query<
resource: Tuesday.Projects.Task,
filter: #Ash.Filter<is_complete == true and contains(title, "test")>,
sort: [priority: :desc, due_date: :desc],
limit: 10,
offset: 20,
select: [:id, :priority, :title, :due_date, :story_point]
>

The query_opts given to build/2 is a keyword representation of the inputs we
would give to the individual functions in Ash.Query when called individually. As
we can see from the resulting Ash.Query struct, both methods yield the same
struct.

4.16. Summary
The chapter introduced the core functionalities of Ash.Query, focusing on querying
data from resources like the Tuesday application’s Task resource. Below are the
key concepts explored.

4.16.1. Key Concepts
• Query Construction: Ash.Query enables building queries with functions like

63

new/2 to initialize a query for a resource (e.g., Ash.Query.new(Task)),
filter/2 for trusted developer-defined filters (e.g., filter(is_complete:
true)), and filter_input/2 for sanitized user input, supporting complex
conditions via Ash.Expr.expr/1 (e.g., expr(contains(title, "Task 1"))).
The build/3 function consolidates multiple query operations into a single call.
• Field Selection: Functions like select/3 limit query results to specific fields
(e.g., select([:id,
overwriting

existing

:title])), ensure_selected/2 adds fields without
selections,

deselect/2

removes

fields,

and

selecting?/2 checks if a field is selected, providing precise control over
returned data.
• Sorting: sort/3 orders results by attributes (e.g., sort(priority: :desc)),
while sort_input/3 handles user-driven sorting with sanitized inputs (e.g.,
sort_input("-title")), supporting ascending/descending directions and
null handling.
• Limit and Offset: limit/2 caps the number of returned records (e.g.,
limit(5)), and offset/2 skips records for pagination (e.g., offset(10)),
forming the basis for offset-based pagination.
• Ecto Integration and Escape Hatches: Ash.Query abstracts over Ecto.Query,
generating equivalent Ecto queries (accessible via data_layer_query/1).
Escape hatches allow direct Ecto usage (e.g., Ecto.Query.where/3) for rare
cases not covered by Ash, ensuring flexibility.

64

Chapter 5. Changeset
In the context of version control software like Git, Changeset is a collection of
modifications to files or folders that represents a distinct change in the repository.
Ecto borrowed this term for a data structure, specifically a struct, that holds all the
changes that are required to be made on a record. We call this data structure Ecto
Changeset. Ash further borrowed it to represent the changes to be made to an Ash
Resource and calls it Ash Changeset.
While the extensive list of Ash Changeset functions might seem daunting,
understanding its role is simpler when viewed conceptually. It is a struct that holds
the user’s intent to modify data in the underlying database.

5.1. What is Ash Changeset?
Imagine visiting a physical bank to update account details. The bank staff provides
us a form to request changes, such as updating a permanent address or phone
number. Completing the form doesn’t instantly update the account; it captures the
intent. The staff reviews the form, verifying its validity like checking for a signature
or proof of address, for instance. If anything is missing, they return the form for
corrections. They apply the changes to the account only when the form is fully
valid.
A Changeset is like the change request form at a bank—a structured way to
propose, validate, and apply changes to data only when all conditions are met. In
an Ash application, whenever we need to create, update, or delete records, we work
with an Ash Changeset. It collects proposed changes and validates them against
predefined rules.
As developers, we don’t write code to directly modify data. Instead, we write code
to capture requirements as data points. Ash.Changeset provides a comprehensive
way to capture these requirements, and Ash functions, like Ash.update/3, handles
applying them to the database if the changeset is valid.
Ash.Changeset is an Elixir struct defined in the Ash.Changeset module. It
represents the business need to insert a new record, update or delete an existing

65

one, capturing all related requirements. The module also includes functions to
interact with this struct, offering a robust API to create and modify the data
representing business requirements.
The Ash.Changeset shown below is for inserting a new record for the
Tuesday.Projects.Task resource. As we can see, it contains over 40 keys to hold
data throughout its lifecycle. The Ash.Changeset module also provides over 70+
public functions that help us work with this large data structure. In this chapter, we
make it easy to understand commonly used functions, grouped into three thematic
areas for easier understanding.
%Ash.Changeset{
action_type: :update,
action_select: [],
invalid_keys: %{map: %{}, __struct__: MapSet},
tenant: nil,
dirty_hooks: [],
context: %{},
after_transaction: [],
atomic_after_action: [],
context_changes: %{},
arguments: %{},
filter: nil,
load: [],
attributes: %{},
no_atomic_constraints: [],
data: %{},
added_filter: nil,
around_action: [],
timeout: nil,
action_failed?: false,
casted_arguments: %{},
phase: :pending,
before_transaction: [],
to_tenant: nil,
params: %{},
action: nil,
before_action: [],
domain: nil,
relationships: %{},

66

around_transaction: [],
select: nil,
atomics: [],
__validated_for_action__: nil,
resource: Tuesday.Projects.Task,
casted_attributes: %{},
defaults: [],
atomic_changes: [],
handle_errors: nil,
attribute_changes: %{},
atomic_validations: [],
errors: [],
valid?: true,
after_action: []
}

By the end of this chapter, we will have a comprehensive understanding of how to
leverage Ash.Changeset to handle data transformations effectively. Here’s what
we’ll learn:
1. Changeset Initialization and Filtering
We’ll learn how to create and initialize changesets using new/1 and apply
filters with filter/2 to constrain records for updates or deletions, setting the
foundation for data modifications.
2. User Input Management
We will learn how to propose changes to resource attributes using functions
like

change_attribute/3,

force_change_attribute/3,

and

changing_attribute?/2
3. Managing change
With the changeset already containing all the changes required by the user,
we’ll explore functions that helps us to work with these changes like
clear_change/2,

fetch_change/2,

update_change/3

and

apply_attributes/2. Finally validate the changes using is_valid?/1.
Throughout this chapter, we will use the Task resource from the Tuesday project to
learn the various concepts of Ash.Changeset. All the code shown below is
executable from within the iex -S mix shell of the Tuesday project. To follow
along, just ensure that you have the Tuesday project set up with all migrations and

67

seed data included. If you are unsure, you can run mix ecto.reset, which will
handle setting up everything needed for this chapter. We will reference Chaaru’s
Dev Stories to provide context for each question.

Changeset Initialization and Filtering
Our work with Changeset starts with first getting a base changeset which we can
start building upon further. So let’s look at how to get these base changesets.

5.2. Understanding the Ash Changeset struct
As we have previously seen, %Ash.Changeset{} struct contains about 40 different
keys. In this section, we will learn the most commonly used keys and their usage
which will form an important foundation knowledge for us to understand the rest
of this chapter.
Let’s start with creating a new changeset using Ash.Changeset.new/1 using
Tuesday.Projects.Task resource.
iex> Ash.Changeset.new(Task)
#Ash.Changeset<
action_type: :create,
resource: Tuesday.Projects.Task, ①
data: #Tuesday.Projects.Task<
id: nil,
title: nil,
...
>,
valid?: true
>

① This key might not be seen in your IEx because it’s hidden by default but the
value is nevertheless set.
As seen above, Ash.Changeset.new/1 return an Ash.Changeset struct with
values for 4 keys set as highlighted above. action_type is set to :create because
we passed in the resource module as input indicating we want to create a new
record related to this resource. resource key is set to the module name we have
passed, data key stores the original data passed to the changeset for which changes

68

are being collected. Since we are creating a new data, the original data is set to an
empty struct of Tuesday.Projects.Task. Finally, valid? key is set to true
because we just created a new changeset and we haven’t performed any action
with the changeset yet. If any of the actions performed in the changeset makes it
invalid, like an incorrect value for an attribute, valid? changes to false.
Now, let’s create a new changeset using the same Ash.Changeset.new/1 but using
an existing Task record.
iex> task = Ash.read_first!(Task, authorize?: false)
iex> Ash.Changeset.new(task)
#Ash.Changeset<
action_type: :update,
resource: Tuesday.Projects.Task, ①
data: #Tuesday.Projects.Task<
id: "29271086-5030-4fd0-baa5-1ba974444112",
title: "Task 1",
...
>,
valid?: true
>

① This key might not be seen in your IEx because it’s hidden by default but the
value is nevertheless set.
This time, action_type key stores the value :update because we have passed in
an existing task record and not the Task module. A changeset created for an
existing record can only be for two action types: :update or :destroy. Since we
didn’t mention our intent so far, Ash defaults it to :update. We didn’t pass the
resource module name this time, but Ash still figures out that the task record we
have given belongs to Tuesday.Projects.Task resource and populates the
resource key with it. The data key is set to the original value and in this case the
task record for which the changeset was created. We can see that the id and other
attributes of the task record in data key has values now because this is an existing
record while in the previous case we had nil values. Finally, valid? is set to true
as explained in the previous section.
What do we learn from this simple exercise? We can see how Ash.Changeset
mimics the bank form example we have shared in the beginning of the chapter. The

69

struct collects various data depending on the intent of the user.
Following are a few more common keys that we will come across in our work with
Ash Changeset:
attributes
This key stores a map value with each key of this map storing the changes we
want to make to our original data’s attributes. Let’s say we intent to change the
title attribute of a task record to "New Task Title", then the attributes key
of Changeset looks as shown below:
%Ash.Changeset{
attributes: %{title: "New Task Title"}
}

filter
This key stores an Ash.Filter struct which contains all the filter conditions
passed to the changeset. This is akin to WHERE clause in an SQL but more
powerful. Assuming we want to apply our change to task with priority value
3, then filter key of Changeset looks as shown below:
%Ash.Changeset{
filter: #Ash.Filter<priority == 3>
}

Of course, we haven’t seen how to change attribute or set a filter yet which will see
later below but for now, we can understand how different keys of changeset struct
holds various user intents. errors:: This key holds information about all error
messages collected in the lifecycle of changeset. This key holds a list of maps where
each map contains detailed information about the error.
There are so many other fields to explore but with these basic understanding of the
changeset keys, we are good to follow the rest of the chapter and for most common
uses of changeset.

70

5.3. How to create a new changeset and insert or update a record
using it?
Dev Story
Chaaru understands the concept of Changeset from our description
above. But there are still questions lingering in his mind. She has
previously used Ash.create(Task,

%{title:

"Hello"}) to

insert a record which doesn’t seem to use Ash Changeset. She has
also seen several other Ash developers write code using Code
Interface function which again seems to not use Changeset. So she
is wondering if she really needs to learn Changeset and if so, how to
create one?
Every insert, update or delete happens in Ash only through Changeset and there is
no other way. However, to provide good developer experience, Ash hides this
complexity of creating and managing the changeset most of the time.
For instance, Chaaru’s question is around the code Ash.create(Task, %{title:
"Hello"}). Behind the scenes, Ash creates an Ash.Changeset before attempting to
insert the record. We can verify this with an invalid insert and see what Ash
returns.
Let’s attempt to create a Task with an empty params. Since the title attribute is
required, this operation should fail with an error.
iex> {:error, %{changeset: changeset}} =

Ash.create(Task, %{},

authorize?: false)
iex> changeset
#Ash.Changeset<
domain: Tuesday.Projects,
action_type: :create,
action: :create,
attributes: %{
id: "43b1276f-3f1f-4b76-8d0d-7c9af61bed24",
priority: 3,
inserted_at: ~U[2025-04-28 12:07:57.662789Z],
is_complete: false,

71

start_date: ~D[2025-04-28],
story_point: 3,
updated_at: ~U[2025-04-28 12:07:57.662789Z]
},
relationships: %{},
errors: [
%Ash.Error.Changes.Required{
field: :title,
type: :attribute,
resource: Tuesday.Projects.Task,
splode: Ash.Error,
bread_crumbs: [],
vars: [],
path: [],
stacktrace: #Splode.Stacktrace<>,
class: :invalid
},
%Ash.Error.Changes.Required{
field: :project_id,
type: :attribute,
resource: Tuesday.Projects.Task,
splode: Ash.Error,
bread_crumbs: [],
vars: [],
path: [],
stacktrace: #Splode.Stacktrace<>,
class: :invalid
}
],
data: #Tuesday.Projects.Task<
id: nil,
title: nil,
project_id: nil,
...
>,
valid?: false
>

If we inspect the changeset variable, we can see that it is a complete
Ash.Changeset struct with error information about what caused the failure. This
verifies our claim that a Changeset is used even if we did not explicitly create it.

72

Ash’s Code Interface functions, which we will learn about in subsequent chapters,
also hide the creation of Changeset from us. We also recommend using them over
directly working with raw changesets or actions. This prompts the question: why
should we learn about Changeset if we do not use it directly?
Even though we can use Ash without directly interacting with Changeset, certain
business customizations require functionality beyond Ash’s built-in macros.
Without a solid understanding of Changeset, we may spend a disproportionate
amount of time completing these tasks due to a lack of foundational knowledge
about how Ash operates. This can lead to frustration, as we have experienced
firsthand and observed in the teams we have trained. In our view, understanding
Changeset is critical for all record modifications, just as understanding Ash.Query
is essential for read operations.
Assuming we want to create a new Task record, we can create a changeset using
the Ash.Changeset.new/1 function, passing the Ash resource module name as the
argument as shown below:
iex> project = Ash.read_first!(Project, authorize?: false)
iex> changeset = Ash.Changeset.new(Task)
iex> params = %{title: "Publish Ash Book", project_id: project.id}
iex> Ash.create(changeset, params, authorize?: false)

Previously, we tried Ash.create by passing the Task resource as the argument
instead of a changeset. When we pass a resource instead of a changeset, Ash
initializes a new changeset using Ash.Changeset.new(Task), as we have done
above. This is why we received an error changeset even though we did not send a
changeset to Ash.create in our first example.
If our intention is to update a single existing record, then we still use the same
Ash.Changeset.new/1 function but this time, instead of passing in the Ash
resource module name, we pass in the record struct that needs to be modified. We
will cover how to update multiple records in the next section.
Let’s first fetch one task record from the database for updating

73

iex> task_one = Ash.read_first!(Task, authorize?: false)
[debug] # (Cleaned up query)
SELECT id, description, title, inserted_at, organization_id, start_date,
updated_at, project_id, story_point, is_done, due_date, parent_task_id
FROM tasks LIMIT 1;
#Tuesday.Projects.Task<
id: "ea2aea1d-f48d-443f-bb7e-582be0c90f37",
title: "Task 0"
...>

We can now pass this record to Ash.Changeset.new to initialize a new changeset
which is then used to update it.
iex>

changeset = Ash.Changeset.new(task_one)

#Ash.Changeset<
action_type: :update,
data: #Tuesday.Projects.Task<
id: "ea2aea1d-f48d-443f-bb7e-582be0c90f37", ①
title: "Task 0",
...
>,
valid?: true
>

① This is ID of the task we are updating.
As we can see above, this initializes a new changeset of action_type: update and
it contains the original task_one record passed to it under the data key.
Finally, when we call Ash.update, with the changeset and params, Ash then
validates the params against the predefined rules, updates the changeset struct
and if the changeset is still valid, then proceeds to make changes to the database.
iex> params = %{title: "Updated task title using changeset"}
iex> Ash.update(changeset, params, authorize?: false)
[debug] # Truncated cleaned up query
UPDATE tasks SET title = 'Updated task title using changeset' .... WHERE
id = 'ea2aea1d-f48d-443f-bb7e-582be0c90f37' ①

74

① The WHERE clause matches with the ID of the task we fetched earlier.
In practice, Ash.Changeset.new/1 is rarely used. What is normally used is
Ash.Changeset.for_create, for_update/3, for_destroy, or for_action/3.
Since

we

haven’t

learned

about

Ash

actions

yet,

we

are

using

Ash.Changeset.new/1 which is the underlying function being used by these
function.

5.3.1. Applying Filters with filter/2
Dev Story
Chaaru wants to update or delete a task record only if it matches a
certain condition.
In the previous question, we addressed the requirement to update a single record
without any conditions. But when updating or destroying records, we often have
additional conditions to be met. The Ash.Changeset.filter/2 function allows us
to add a filter expression to a changeset, ensuring that record gets updated if it
satisfies the condition. For example, to prepare a changeset that updates the given
task only if its is_complete status is true:
iex> task_one = Ash.read_first!(Task, authorize?: false)
iex> changeset = Ash.Changeset.new(task_one)
iex> changeset = Ash.Changeset.change_attribute(changeset, :title,
"Updated title")
iex> changeset = Ash.Changeset.filter(changeset, is_complete: false)
iex>

Here, filter/2 adds a condition to the changeset, restricting any subsequent
update or destroy action to tasks where is_complete equals "false". All these
filters at the end are translated into database WHERE clauses.
If we now run Ash.update on this changeset, it only gets executed if all the filters
match.

75

User Input Management
Dev Story
Chaaru wants to update the records with user inputs. Currently she
provides the user inputs via Ash.update and Ash.create, but she
wants to make use of the changeset functions to capture the user
inputs.
There are two kinds of possible user inputs.
1. User inputs for Resource attributes
2. User inputs for Ash Action arguments
Since we haven’t covered Action yet, we will cover only Resource attributes for
now. You will learn about user inputs for Action arguments in the subsequent
chapter.

5.4. Changing an Attribute with change_attribute/3
To

update

an

attribute

in

the

changeset,

we

use

Ash.Changeset.change_attribute/3. This updates the attributes key of the
changeset only if the proposed change is different from the attribute value of the
original data present in data key of the changeset.
iex> task = Ash.read_first!(Task, authorize?: false)
#Tuesday.Projects.Task<
id: "29271086-5030-4fd0-baa5-1ba974444112",
title: "Task 1"
...
>
iex> changeset = Ash.Changeset.new(task)
iex> Ash.Changeset.change_attribute(changeset, :title, "Updated Title")
#Ash.Changeset<
attributes: %{title: "Updated Title"},
data: #Tuesday.Projects.Task<
title: "Task 1",

76

>

change_attribute updated the attributes key of the changeset because the
value given for title is different from the value which was already existing for
title under data key as highlighted above.
iex> Ash.Changeset.change_attribute(changeset, :title, "Task 1")
#Ash.Changeset<
attributes: %{},
data: #Tuesday.Projects.Task<
title: "Task 1",
>

In the above case, we are setting the value of title which is same as the original
value and hence attributes key of changeset is not updated.

5.5. Applying Multiple Attribute Changes with change_attributes/2
For updating multiple attributes at once, Ash.Changeset.change_attributes/2
applies change_attribute/3 for each key-value pair in a map. To update a task’s
title and is_complete status in one go:
iex> changeset = Ash.Changeset.new(task)
iex> changeset = Ash.Changeset.change_attributes(changeset, %{title:
"Final Plan", is_complete: true})

5.6. Forcing Attribute Changes with force_change_attribute/3
To bypass writability restrictions, Ash.Changeset.force_change_attribute/3
changes an attribute even if it’s not writable. Non-writable attributes are those that
have an explicit writable? false set in their attribute definition. By default
inserted_at and updated_at attributes are marked not writable in Ash
resources.
Let’s see what happens when we try to update these non-writable fields:
iex> changeset = Ash.Changeset.new(Task)

77

iex> Ash.Changeset.change_attribute(changeset, :inserted_at, DateTime
.utc_now())
...
%Ash.Error.Changes.InvalidAttribute{
field: :inserted_at,
message: "Attribute is not writable",
private_vars: nil,
value: ~U[2025-04-23 17:04:20.644081Z],
splode: nil,
bread_crumbs: [],
vars: [],
path: [],
stacktrace: #Splode.Stacktrace<>,
class: :invalid
}
...

This will result in attribute not writable error as shown above as we are using the
change_attribute function on non-writable attribute.
We can override the option set in attribute definition and write to them using
force_change_attribute/3 as shown below:
iex> changeset = Ash.Changeset.new(Task)
iex> Ash.Changeset.force_change_attribute(changeset, :inserted_at,
DateTime.utc_now())
#Ash.Changeset<
attributes: %{inserted_at: ~U[2025-04-20 06:40:26.724973Z]},
data: #Tuesday.Projects.Task<
id: nil,
inserted_at: nil,
>

Similar to change_attributes/2 and change_new_attribute/3, we have
variants that forces change for non-writable fields. They work the same way as the
other functions except these work on non-writable attributes.
To force-update multiple fields:

78

iex> changeset = Ash.Changeset.new(task)
iex> changeset = Ash.Changeset.force_change_attributes(changeset,
%{inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()})

To

force

a

change

only

if

the

attribute

is

unchanged,

we

can

use

Ash.Changeset.force_change_new_attribute/3. For example:
iex> changeset = Ash.Changeset.new(task)
iex> changeset = Ash.Changeset.force_change_new_attribute(changeset,
:inserted_at, DateTime.utc_now())
# Because the previous statement already updates `inserted_at`, the
below one will not change it.
iex> changeset = Ash.Changeset.force_change_new_attribute(changeset,
:inserted_at, DateTime.add(DateTime.utc_now, 10, :day))

5.7. Checking Attribute Changes with changing_attribute?/2
To verify if an attribute is being changed,
Ash.Changeset.changing_attribute?/2 returns true if a change exists. For
example:
iex> changeset = Ash.Changeset.new(task) |> Ash.Changeset
.change_attribute(:title, "New Title")
iex> Ash.Changeset.changing_attribute?(changeset, :title) # Returns
true

This helps us implement conditional logic based on change status.

5.8. Checking Any Attribute Changes with changing_attributes?/1
To

check

if

any

attribute

Ash.Changeset.changing_attributes?/1

is

returns

being
true

if

changed,
the

changeset

includes attribute changes:
iex> changeset = Ash.Changeset.new(task) |> Ash.Changeset
.change_attribute(:title, "New Title")
iex> changeset = Ash.Changeset.changing_attributes?(changeset) #

79

Returns true

This is useful for validating whether modifications are pending.

Managing Change
Dev Story
Chaaru wants to know how to work with the changed data itself. So
far, she is able to create a new changeset and also propose changes
to the record using user inputs. But how can she work with the
proposed changes itself for complex use cases?
So far, we have worked with creating a new changeset and setting some values to it.
But we haven’t looked at how to work with the list of changes stored in the
changeset itself. In this section, we will look into those functions that help us work
with the change data.

5.9. Inspecting Changes with fetch_change/2
To retrieve the new value of an attribute from the changeset, we can use
Ash.Changeset.fetch_change/2. This returns the proposed value or :error if
no change exists. This is helpful for conditional logic based on pending changes.
iex> changeset = Ash.Changeset.new(Task) |> Ash.Changeset
.change_attribute(:title, "New Task")
iex> Ash.Changeset.fetch_change(changeset, :title) # Returns {:ok, "New
Task"}

If no change exists for the attribute, it return :error.
iex> Ash.Changeset.fetch_change(changeset, :priority)
:error

80

5.10. Modifying Changes with update_change/3
To transform an existing attribute change, Ash.Changeset.update_change/3
applies a provided function to the pending value. This is useful for dynamic
adjustments, such as appending " - Updated" static text to a task’s title:
iex> changeset = Ash.Changeset.new(task) |> Ash.Changeset
.change_attribute(:title, "Project Plan")
#Ash.Changeset<
attributes: %{title: "Project Plan"},
...>
iex> changeset = Ash.Changeset.update_change(changeset, :title, &(&1 <>
" - Updated"))
#Ash.Changeset<
attributes: %{title: "Project Plan - Updated"},
...>

This updates the title change to "Project Plan - Updated". The function takes
the changeset, the attribute name, and a function that transforms the value of that
attribute. If no change exists for the attribute, the changeset remains unchanged.
Below, we try update_change/3 on the :description attribute which has no
change recorded and we can see that it just returns the same old changeset without
any update.
changeset = Ash.Changeset.update_change(changeset, :description, &(&1 <>
" - Updated"))
# Returns the old changeset as it's.
#Ash.Changeset<
attributes: %{title: "Project Plan - Updated"},
...>

It’s important to note update_change/3 works on the proposed
changes that already exist in the changeset. It doesn’t use the
original data but the value in the :attributes of Changeset which
holds the previous uncommitted changes.

81

5.11. Applying Changes with apply_attributes/2
To

merge

pending

attribute

changes

with

the

original

record

data,

Ash.Changeset.apply_attributes/2 returns the updated record struct if the
changeset is valid. This is useful for previewing or testing changes without
committing them to the database. For example, to see the result of updating a task’s
title and status:
iex> changeset = Ash.Changeset.new(task) |> Ash.Changeset
.change_attributes(%{title: "Final Plan"})
iex> Ash.Changeset.apply_attributes(changeset)

This returns a struct reflecting the original task with the new title applied. The
optional second argument, a keyword list, allows customization, such as :force to
bypass validation.

5.12. Clearing Changes with clear_change/2
To remove a pending attribute or relationship change from a changeset, we use
Ash.Changeset.clear_change/2. This is useful when we decide to discard a
change before finalizing the action. For example, in the Tuesday app, if we initially
set a new title for a task but later choose to revert it.
iex> changeset = Ash.Changeset.new(task) |> Ash.Changeset
.change_attribute(:title, "Revised Plan")
iex> changeset = Ash.Changeset.clear_change(changeset, :title)

This removes the title change, leaving the changeset with the original value. If the
specified field has no pending change, the changeset remains unaffected, ensuring
safe operations.

5.13. Adding Errors with add_error/3
To

flag

a

changeset

as

invalid

and

attach

an

error,

we

use

Ash.Changeset.add_error/3. This function adds an error to the changeset’s
error list and also marks it as invalid to prevent further processing.

82

Below we change the :title of an existing task and check if the newly modified
title is at least 5 characters. If it’s less than 5 characters, then we add an error to the
changeset.
iex> task = Ash.read_first!(Task, authorize?: false)
iex> changeset = Ash.Changeset.new(task) |> Ash.Changeset
.change_attribute(:title, "One")
iex> {:ok, changed_title} = Ash.Changeset.fetch_change(changeset,
:title)
iex> changeset = if String.length(changed_title) < 5, do: Ash.Changeset
.add_error(changeset, "title must be at least 5 characters"), else:
changeset
#Ash.Changeset<
attributes: %{title: "One"},
errors: [
%Ash.Error.Changes.InvalidChanges{
fields: nil,
message: "title must be at least 5 characters",
}
]>
iex> changeset.valid?
false
iex> Ash.Changeset.is_valid(changeset)
false

We can also determine if a changeset is valid and ready for execution by using
Ash.Changeset.is_valid/1. This function serves as a guard, returning true if
the changeset has no errors and all validations have passed, or false otherwise. In
the above example, it returns false because we have added an error to the
changeset.

5.14. Summary
The chapter delved into the Ash.Changeset module, a critical component for
managing data modifications, using the Tuesday application’s Task resource as a
case study. Below are the key concepts covered.

83

5.14.1. Key Concepts
• Changeset Overview: Ash.Changeset is a struct that captures the intent to
create, update, or delete records in an Ash resource, akin to a bank form for
proposing and validating changes. It stores data like attributes, filters, and
errors,

and

is

used

implicitly

in

functions

like

Ash.create/3

and

Ash.update/3.
• Initialization and Filtering: Ash.Changeset.new/1 initializes a changeset for
creating a new record (with a resource module) or updating an existing one
(with a record), setting keys like action_type, resource, data, and valid?.
The filter/2 function adds conditions (e.g., filter(is_complete: true))
to restrict updates or deletions to matching records.
• User Input Management: Functions like change_attribute/3 and
change_attributes/2 propose attribute changes (e.g.,
change_attribute(changeset, :title, "New Title")), while
force_change_attribute/3 bypasses writability restrictions for nonwritable fields (e.g., inserted_at). changing_attribute?/2 and
changing_attributes?/1 check for pending changes.
• Managing Changes: fetch_change/2 retrieves proposed attribute values,
update_change/3 transforms existing changes (e.g., appending text to a title),
apply_attributes/2 previews changes without database commits,
clear_change/2 removes pending changes, and add_error/3 flags invalid
changes, with is_valid?/1 verifying changeset validity.

84

Chapter 6. Actions
We have explored Ash.Query and Ash.Changeset in previous chapters for
performing CRUD operations on Ash resources. Ash Actions provide an abstraction
over both, enabling reusable logic.
In simple terms, defining Ash Actions is akin to defining a function: a function is
defined once and reused as needed. Similarly, Ash Actions allow us to execute an
Ash.Changeset or Ash.Query multiple times across our application.
Ash supports five types of actions:
• Create
• Read
• Update
• Destroy
• Generic
The Read action abstracts over Ash.Query, while Create, Update, and Destroy
actions abstract over Ash.Changeset. Together, these four actions address
standard CRUD needs in the application. In addition, all CRUD actions support a
manual mode, allowing us to bypass Ash’s default behavior and directly modify the
database query for greater flexibility in rare cases where Ash’s standard
capabilities are limiting. Generic actions are versatile, accepting any input and
producing any output without specific constraints on their functionality.
Throughout this chapter, we will use the Task resource from Tuesday to illustrate
the different actions. We have a lot to cover, so let’s get started with a simple one.

6.1. What are Default and Primary Actions?
All resources in Tuesday are configured with default actions already, and we have
been using them without knowing they were actions. Let’s understand them first.
The Task resource in Tuesday already has the default actions defined as shown

85

below:
defmodule Tuesday.Projects.Task do
...
actions do
defaults [:read, :destroy, create: :*, update: :*]
end
end

Where did we use them so far? In both the Ash Query and Changeset chapters, we
have used Ash.read! or Ash.read_first! to read task records from the database,
as shown below:
iex> Ash.Query.new(Task) |> Ash.Query.select([:id, :title]) |> Ash
.read!(authorize?: false)
iex> Ash.read_first!(Tuesday.Projects.Task, authorize?: false)

To verify that the above code is using the defaults config in the Task resource,
let’s go ahead and remove the :read option from the defaults.
defmodule Tuesday.Projects.Task do
...
actions do
defaults [:destroy, create: :*, update: :*] ①
end
end

① Removed :read option
Now let’s go back to the IEx shell and run Ash.read_first!. This time, it will
result in an error, as seen below:
iex> recompile
iex> Ash.read_first!(Tuesday.Projects.Task, authorize?: false)
** (Ash.Error.Invalid)
Invalid Error
* No primary action of type :read for resource Tuesday.Projects.Task,

86

and no action specified

This verifies that Ash had been using the default :read action. When we call
Ash.read!, Ash looks for a :read type action marked as primary?: true and
invokes that action with the user query. Similarly, if we invoke Ash.create!, it
looks for a :create type action marked as primary?: true. For Ash.update!, it
looks for a primary :update action, and for Ash.destroy!, it looks for a primary
:destroy action.
This confirms that Ash uses the default :read action. When we call Ash.read!/2,
Ash selects the :read action marked as primary?: true and executes it with the
provided query.
Similarly, Ash.create!/3 targets the :create action marked primary?: true,
Ash.update!/3 targets a primary :update action, and Ash.destroy!/3 targets a
primary :destroy action.

6.2. How Do I Define a read Type Action in Ash?
The read type actions in Ash make use of Ash.Query to perform read-only
operations on the data represented by the Ash Resources. All actions are defined
inside the actions block in the Ash Resource. The read action is the simplest to
define. We use the read macro followed by a name we want to give to this action.
Below, we show a simple read type action named :list_tasks, as defined in
Tuesday.Projects.Task:

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects.Task do
actions do
read :list_tasks
end
end

To make use of this action when we invoke Ash.read!, we can explicitly pass
options to Ash.read!, as shown below:
iex> Ash.read!(Tuesday.Projects.Task, authorize?: false, action:

87

:list_tasks)
[
#Tuesday.Projects.Task<...>,
#Tuesday.Projects.Task<...>
...
]

The :list_tasks action we defined is nearly identical to the default :read action,
with two key differences:
• The default read type action is named :read, while ours is named
:list_tasks.
• The default read type action is automatically marked primary?:

true,

whereas :list_tasks is not. Consequently, when invoking Ash.read!/2, we
must explicitly specify the :list_tasks action; otherwise, Ash.read!/2
defaults to the primary :read action.
We can make our :list_tasks primary if needed by configuring it as shown
below:
actions do
read :list_tasks do
primary? true
end
end

Each type of action can have only one action marked as primary?: true. So, when
we mark :list_tasks as primary, we need to remove the :read action from the
defaults, as it’s no longer needed, and Ash would complain if we don’t remove it.
With our new action marked as primary, we should now be able to use our action
with Ash.read! without having to explicitly pass the action option, as we did
earlier:
iex> Ash.read!(Tuesday.Projects.Task, authorize?: false)

We have seen a small glimpse of what read actions can do. It is possible to add

88

options for filters and pagination. We will be looking at those features of Ash later
in this chapter.

6.3. What is the Difference Between Action Type and Action Name?
Using Ash Action’s defaults syntax can make it tricky to differentiate between
action types and action names, as we experienced early on. Ash supports five action
types: create, read, update, destroy, and action (generic), each defined by a
corresponding macro. In the previous section, we defined a read type action:
defmodule Tuesday.Projects.Task do
actions do
read :list_tasks
end
end

Here, the read macro specifies the action type, and :list_tasks is the action
name. Default actions, created via the defaults syntax, often have matching type
and name, as shown below:
defmodule Tuesday.Projects.Task do
actions do
read :read do
primary? true
end
end
end

There is no limit to the number of actions we can define for a given action type. We
can create multiple read type actions with unique names, each serving a distinct
business purpose with specific criteria. In Tuesday, we prioritize descriptive action
names over generic ones. For example, the Task resource defines four read type
actions. To understand action usage, review the actions in other Tuesday resources.
It’s fine if some details are unclear, as we haven’t covered all aspects yet. == How to
Define create, update, and destroy Actions in Ash?
The create, update, and destroy action types in Ash use Ash.Changeset to
perform mutations on data in Ash resources. Their syntax is similar to the read

89

action type but requires specific configurations, as we’ll explore in this section.
To begin, let’s remove the defaults configuration from the Task resource. If we’ve
followed along, we’ve already removed :read from defaults, and now we can
remove the entire line from the actions block:
defaults [:destroy, create: :*, update: :*]

and replace it with newly defined actions, as shown below:
defmodule Tuesday.Projects.Task do
actions do
create :create do
primary? true
end
update :update do
primary? true
end
destroy :destroy do
primary? true
end
end
end

We use the action type macro (create, update, destroy) and specify the action
name as the first argument. Here, we use matching names to replicate default
behavior, though in practice, we prefer descriptive names, as noted earlier.
Although the actions are defined, these actions are not yet fully functional. Let’s see
why in the IEx shell:
iex> Ash.create!(Tuesday.Projects.Task, %{title: "Hello world"})
** (Ash.Error.Invalid)
Bread Crumbs:
> Error returned from: Tuesday.Projects.Task.create
Invalid Error
* No such input `title` for action Tuesday.Projects.Task.create

90

The attribute exists on Tuesday.Projects.Task, but is not accepted by
Tuesday.Projects.Task.create
Perhaps we meant to add it to the accept list for Tuesday.Projects.Task
.create?
No valid inputs exist

A similar error occurs with Ash.update!/3 when updating a task. However,
Ash.destroy!/3 works without issues:
iex> task = Ash.Generator.generate(Tuesday.Generator.task())
iex> Ash.destroy!(task, authorize?: false)
[debug]
DELETE FROM "tasks" AS t0 WHERE (t0."id" = $1) ["d87cc5df-41ff-44e0b697-0c3d92166983"]

As we can see, Ash.destroy! worked by deleting the task record using the
:destroy action we just defined as primary.
We use Ash.Generator.generate/1 to create a task record since
the

primary

:create

action

is

currently

non-functional.

Ash.Generator is covered later in the book. For now, it allows
bypassing the resource’s actions to insert a task. Curious? Check
tests/support/generator.ex for the generator code.
The reason why our create and update actions don’t work can be identified from
the defaults configuration, which was:
actions do
defaults [:read, :destroy, create: :*, update: :*]
end

While read and destroy actions were configured using an :atom name matching
the type, create and update types use a keyword list. This is what we are missing
in our replication of create and update action types.

91

Both these action types require us to explicitly define the allowed fields for creation
and update. :* means we allow all the attributes defined in the resource that are
marked as public?: true.
Let’s go back and redefine both create and update action types:
defmodule Tuesday.Projects.Task do
actions do
create :create do
primary? true
accept :*
end
update :update do
primary? true
accept :*
end
end
end

With this change, we are now able to both create and update tasks using our newly
defined primary actions:
iex> project = Ash.read_first!(Tuesday.Projects.Project, authorize?:
false)
iex> Ash.create!(Tuesday.Projects.Task, %{title: "Hello world!",
project_id: project.id}, authorize?: false)

iex> task = Ash.read_first!(Tuesday.Projects.Task, authorize?: false)
iex> Ash.update!(task, %{title: "Updated title!"}, authorize?: false)

We have allowed all public attributes using :*. Alternatively, we could also specify
which attributes are allowed by providing a list of attribute names specifically:

92

defmodule Tuesday.Projects.Task do
actions do
create :create do
primary? true
accept [:title, :project_id]
end
update :update do
primary? true
accept [:title]
end
end
end

With this configuration, trying to update project_id of an existing task will result
in an error, as it’s not allowed in the list of attributes.

6.4. How do I Filter Read Actions in Ash?
Primary read action is the only one where we normally don’t have any filters. For
every other read actions that we create, it only makes sense if we are able to add
some filters or sorts to get different sets of data.
The existing list_tasks action gets us all Task records. Let’s define a new action
that only fetches tasks that have is_complete value set to true.
read :completed_tasks do
filter [is_complete: true]
end

As seen in the above code snippet, our read action is called :completed_tasks.
Writing a filter involves calling the filter macro with a keyword list that acts as a
filter. The keyword list passed here is exactly the same that we would pass to
Ash.Query.filter.
As our complexities grow, we can add additional filters, and they will be combined
with and in our query to the database. For example:

93

read :high_priority_incompleted_tasks do
filter [is_complete: false]
filter [priority: [lt: 3]]
end

It would have been easily possible to combine the two filters in a single filter with
an expanded keyword list like [is_complete: false, priority: [lt: 3]],
but we didn’t do it just to show that multiple filters can be added. This is
particularly useful when our filters become complex.
Multiple instances of filter result in an AND filter at SQL level. To
define OR the different conditions for OR must be part of the same
filter as in filter expr(condition1 or condition2 or
condition3).
So far, we’ve only seen filters with the keyword list syntax but, additionally, we can
use something called expressions for more complex filters. Expressions offer
sophisticated options to add filters, and their syntax is pretty much similar to SQL.
read :high_priority_completed_tasks do
filter expr(is_complete == true and priority > 3)
end

As seen above, as our argument to the filter function, we write our expression in
the above format calling the expr() macro with an argument as per our
requirement, which follows an SQL-like syntax. It is quite a simple expression,
which we’ve translated from the keyword list example that we’ve seen before.

6.5. What is a Resource Preparation?
Resource preparations act as a way to modify our query in the read actions. We can
define multiple preparations in our read action, and all of them would modify our
queries one after the other. The format to define a preparation is prepare
[some_preparation].
There are only a total of 4 built-in preparations:

94

1. before_action
2. after_action
3. build
4. set_context
and here we will go through the build preparation that we would need most of the
time. We will learn about before_action and after_action in the subsequent
chapters.
The build preparation converts the given keyword list into actual queries. Below is
an example of how we can define a build preparation to retrieve the latest 5
records:
read :list_tasks do
prepare build(sort: [:inserted_at], limit: 5)
end

The keyword list provided to build is passed on to Ash.Query.build. So every
option accepted by Ash.Query.build is accepted here.

6.6. How to Set or Update Attributes in Create or Update Actions?
The Task resource in Tuesday includes attributes such as title, description,
start_date, due_date, is_complete, and priority. Suppose we want to define
an Update action that allows updating most of these attributes while setting the
priority based on an argument provided during the update. We can achieve this
using the accept, argument, and change directives, as shown below:
defmodule Tuesday.Projects.Task do
actions do
update :update_task do
description "Updates task details and sets priority based on an
argument"
argument :new_priority, :integer
accept [:title, :description, :start_date, :due_date,
:is_complete]
change set_attribute(:priority, arg(:new_priority))

95

end
end
end

Let’s break down this Update action to understand the roles of the argument,
accept, and change directives:
• argument: Defines additional inputs (like new_priority) that can be used in
the action’s logic, separate from the resource’s attributes.
• accept: Specifies which attributes can be directly updated from the input,
acting as a safeguard to ensure only allowed attributes are modified.
• change: Transforms the changeset by setting or updating attributes, often using
arguments or custom logic.
In this example, the accept directive is configured as follows:
accept [:title, :description, :start_date, :due_date, :is_complete]

This allows updates to five attributes of the Task resource: title, description,
start_date, due_date, and is_complete. When the :update_task action is
invoked, Ash includes only these attributes from the input in the changeset. Any
other attributes provided, such as priority or unlisted attributes like created_at,
are ignored, ensuring the action remains secure and predictable.

6.7. Using the argument Directive to Define Inputs
The argument directive enables us to define inputs beyond the resource’s
attributes. In our action, we have:
argument :new_priority, :integer

Here, new_priority is an integer argument that we can pass to the :update_task
action. It is not an attribute of the Task resource but a separate input used to
influence the update process, specifically to set the priority attribute via the
change directive.

96

To use this action, we can call Ash.update! with both attributes and the
new_priority argument:
iex> task = Ash.read_first!(Tuesday.Projects.Task, authorize?: false)
iex> Ash.update!(task, %{title: "Plan Team Meeting", new_priority: 2},
authorize?: false, action: :update_task)

Ash validates that new_priority is an integer and makes it available for use in the
change directive.

6.8. Transforming Data with the change Directive
The change directive allows us to define transformations on the changeset, applied
after input validation but before persisting the record. In our example:
update :update_task do
description "Updates task details and sets priority based on an
argument"
argument :new_priority, :integer
accept [:title, :description, :start_date, :due_date, :is_complete]
change set_attribute(:priority, arg(:new_priority))
end

This

directive

uses

set_attribute/2,

a

built-in

function

from

Ash.Resource.Change.Builtins, to set the priority attribute to the value of the
new_priority argument. The arg(:new_priority) helper retrieves the integer
value provided in the input (like 2 in the above example).
When we execute the :update_task action, Ash processes the list of attributes in
the accept first given in the action (example: title), then applies the change
directive to set priority. Consider the following call:
iex> task = Ash.read_first!(Tuesday.Projects.Task, authorize?: false)
iex> Ash.update!(task, %{title: "Plan Team Meeting", new_priority: 2},
authorize?: false, action: :update_task)

The resulting task record reflects the updated title and the priority set via the

97

change directive:
%Tuesday.Projects.Task{
id: "task-123",
title: "Plan Team Meeting",
description: "Discuss project timeline",
start_date: ~D[2025-04-28],
due_date: ~D[2025-04-30],
is_complete: false,
priority: 2,
created_at: ~U[2025-04-27T10:00:00Z]
}

The change directive provides flexibility to modify the changeset based on
arguments, context, or custom logic, making it a powerful tool for tailoring Update
actions to specific needs.
The same principles apply to Create actions. For example, we could define a Create
action that accepts the same attributes and sets priority based on an argument:
defmodule Tuesday.Projects.Task do
actions do
create :create_task do
description "Creates a task with specified attributes and
priority"
argument :new_priority, :integer
accept [:title, :description, :start_date, :due_date,
:is_complete]
change set_attribute(:priority, arg(:new_priority))
end
end
end

This action allows us to create a task with a specified priority using the
new_priority argument, following the same pattern as the Update action. For
example:
iex> Ash.create!(Tuesday.Projects.Task, %{
...>

98

title: "Plan Team Meeting",

...>

new_priority: 2

...> }, authorize?: false, action: :create_task)

The accept, argument, and change directives work together to ensure that Create
and Update actions are both secure and flexible, allowing precise control over
attribute updates and dynamic transformations.

6.9. How do I Manage the Fields Selected in Read Action?
When using a read action, we may not always want all the attributes to be selected.
Ash actions allow us to configure the fields we want to read from the data store. We
can do so by using the select option in the read action. Let’s see how we can do
that:

lib/tuesday/projects/task.ex
read :list_tasks do
prepare build(select: [:title, :is_complete])
end

In the above code snippet, we’ve modified the list_tasks action with the select
macro by providing a list of attribute names that we want to select.
Since we are selecting only :title and :is_complete, the value of other
attributes of the Task resource will be shown as a %Ash.NotLoaded struct. This
means that it didn’t try to select the value from the database.
We could also modify the behavior of the fields selected in the read action by
changing the attribute definition. By default, all attributes are selected when we
read a resource unless we set the select_by_default? option to false in the
attribute definition.
Tuesday doesn’t have a User resource with a hashed_password field, but it’s very
common in web apps to have one such field. Assuming a User resource has this
hashed_password field, we could disable selecting this field whenever the User
resource is read from the data layer by default.
attribute :hashed_password do

99

select_by_default? false
end

We can still select it, when needed, by using the select option in the read action.

6.10. How do I Ensure Mandatory Fields are Always Loaded in My
Read Action?
While defining an attribute, we can set the always_select? option to true in
order to ensure that the attribute is always selected in the read action. In the Task
resource, we have :story_point configured as always_select? true. So even
though

we

have

already

configured

list_tasks

to

select

:title

and

:is_complete, Ash will still select :story_point:
attribute :story_point, :integer do
constraints min: 1, max: 21
default 3
allow_nil? false
always_select? true
end

This is particularly useful when we have mandatory fields that we always want to
be selected.

6.11. How do I Paginate Read Actions in Ash?
There are two options with which we can perform pagination in Ash:
1. Offset pagination
2. Keyset pagination
Offset pagination is the most common type of pagination that is implemented in
many software applications with small datasets. We can switch to any page by
providing just the limit and offset. It is possible to know the page number that we
are currently in, using offset pagination, as it is easily computable using limit and
offset.

100

In order to configure our resource to be paginated using offset, we do so like below
within our read action:
read :list_tasks do
...
pagination do
offset? true
end
end

The first step is to add a pagination block in our resource. Under that block, we
have specified that our resource supports offset pagination using the option
offset?. Now that we have enabled offset pagination, we can actually paginate our
records. One way to paginate is that we use the page option of the Ash.read
function. It is important to note that calling Ash.read with the page option would
return a %Ash.Page.Offset{} struct instead of records as usual. We generally
refer to the %Ash.Page.Offset{} struct as a page. The records can be found inside
the results key of the results struct.
Let’s get the first page now:
iex(1)> {:ok, page} = Ash.read(Tuesday.Projects.Task, action:
:list_tasks, page: [limit: 2], authorize?: false)
{:ok,
#Ash.Page.Offset<
results: [
#Tuesday.Projects.Task<
id: "0542c8d0-fcc7-4c37-9f32-8d307409432e",
title: "Task 0",
...
>,
#Tuesday.Projects.Task<
id: "8aeb6ef9-811f-4584-b249-f18e3601efc0",
title: "Task 1",
...
>
],
limit: 2,

101

count: nil,
more?: true,
...
>}

In the above code snippet, you may notice that the count value is nil. In order to
actually retrieve the count, we have to set true to the count option like below:
iex(1)> {:ok, page} = Ash.read(Tuesday.Projects.Task, action:
:list_tasks, page: [limit: 2, count: true], authorize?: false)
{:ok,
#Ash.Page.Offset<
... same as previous results
limit: 2,
count: 5,
more?: true,
...
>}

Now, in order to get the next page, i.e., the second page, by using the offset option
of page:
iex(1)> {:ok, page} = Ash.read(Tuesday.Projects.Task, action:
:list_tasks, page: [limit: 2, offset: 2, count: true], authorize?:
false)
{:ok,
#Ash.Page.Offset<
... same as previous results
limit: 2,
offset: 2,
count: 5,
more?: true,
...
>}

page options do not take a sort key but it’s important to have a
fixed sort defined to ensure the paginated results appear in a

102

predictable way and not get randomized by database. We already
have sort option set in the list_tasks action and it is used for the
pagination.
Once we have a page result from Ash.read(), we can use the Ash.page() helper
function to make it easier to paginate. The first argument is the page struct, and the
second argument should be one of the below values, which actually decides what
the function is going to return:
• :first - returns the first page
• :last - returns the last page
• :prev - returns the previous page that is relative to the page given as the first
argument
• :next - returns the next page that is relative to the page given as the first
argument
• :self - returns the page that is given as the argument
• n - returns the `n`th page
Below is an example of how Ash.page() can be called in various ways:
iex> {:ok, page} = Ash.read(Tuesday.Projects.Task, action: :list_tasks,
page: [limit: 2, offset: 2, count: true], authorize?: false)
iex> {:ok, next_page} = Ash.page(page, :next)
iex> {:ok, prev_page} = Ash.page(page, :prev)

6.12. Keyset Pagination
Unlike offset pagination, with keyset pagination, we can’t know the current page
number as there is no offset. How keyset pagination works is that given a keyset of
a record, it can get the records before and after that record as per the limit given.
This is efficient when we have large datasets. Similar to how we configured our
resource in the case of offset pagination, we can start off by adding the pagination
block in our resource under a read action.

103

lib/tuesday/projects/task.ex
read :list_tasks do
prepare build(sort: [:inserted_at], limit: 5)
pagination do
# offset? true
keyset? true
end
end

As seen in the above snippet, we have also set the option of keyset? to true in
order for this action to support keyset pagination. In order to paginate our records,
we can use the Ash.read() function as we did previously, but this time, we will be
returned with a %Ash.Page.Keyset{} page struct.
iex(1)> Ash.read(Tuesday.Projects.Task, action: :list_tasks, page:
[limit: 2], authorize?: false)
{:ok,
#Ash.Page.Keyset<
... same as previous results
>}

In order to get the next page, using the keyset, we can do it like below:
iex(1)> {:ok, page} = Ash.read(Tuesday.Projects.Task, action:
:list_tasks, page: [limit: 2], authorize?: false)
# Retrieve the keyset
iex(2)>

keyset = page.results |> List.last() |> Map.get(:__metadata__)

|> Map.get(:keyset)
"g2wAAAACdAAAAA13C21pY3Jvc2.....LWYxOGUzNjAxZWZjMGo="
iex(3)> Ash.read(Tuesday.Projects.Task, action: :list_tasks, page:
[limit: 2, after: keyset], authorize?: false)
# Next set of results

If we want to get the page before the keyset, we would do it like below:
iex(3)> Ash.read(Tuesday.Projects.Task, action: :list_tasks, page:

104

[limit: 2, before: keyset], authorize?: false)

6.13. Summary
The

chapter

examined

Ash

Actions,

abstractions

over

and

Ash.Query

Ash.Changeset that enable reusable logic for CRUD operations, using the Tuesday
application’s Task resource as an example. Below are the key concepts covered.

6.13.1. Key Concepts
• Action Types and Definitions: Ash supports five action types: create, read,
update, destroy, and generic, defined using macros in a resource’s actions
block (e.g., read :list_tasks). Default actions (e.g., defaults [:read,
:destroy,

create:

:*,

update:

:*]) provide pre-configured CRUD

operations, with primary?: true marking the default action for each type.
• Action Type vs. Name: The action type (e.g., read) is set by the macro, while
the name (e.g., :list_tasks) is user-defined. Default actions often align type
and name (e.g., read :read), but custom actions use descriptive names (e.g.,
:completed_tasks).
• Read

Actions:

Support

filter

for

keyword-based

(e.g.,

filter

[is_complete: true]) or expression-based (e.g., expr(is_complete ==
true

and

priority

>

modifications (e.g., sort:

3)) filtering, and prepare

build for query

[:inserted_at]). The select option limits

attributes (e.g., select [:title]), while always_select? true ensures
mandatory fields are loaded (e.g., :story_point).
• Create/Update Actions: Use accept to define editable attributes (e.g., accept
[:title] or accept :*), argument for additional inputs (e.g., argument
:new_priority, :integer), and change for dynamic transformations (e.g.,
change set_attribute(:priority, arg(:new_priority))).
• Destroy Actions: Require minimal configuration, typically just primary?
true, as they don’t involve attribute validation.

105

Chapter 7. Action LifeCycle Callbacks
In earlier chapters, we explored Ash Actions, which define operations like creating,
updating, or executing custom logic on a resource. Now, we dive into Ash Action
callbacks, the lifecycle hooks that let us extend and customize these actions. For
developers familiar with Ruby on Rails' Active Record or Django, the concept may
ring a bell. Rails' before_save callback or Django’s pre_save signal share
similarities with Ash’s callbacks at a high level—they all allow us to inject logic at
specific points in an operation.
For those new to frameworks with lifecycle hooks, let’s ground the concept with an
example. Suppose we need to insert a comment record into a database when a user
submits it. We might have requirements like notifying a moderator, setting an
attribute value if the author of the comment is the same as the author of the post, or
performing some custom validation of the comment’s content. Ash Action callbacks
let us handle these tasks seamlessly by hooking into the action’s lifecycle.
The following table outlines the six action lifecycle functions in Ash, detailing their
purpose and appropriate use cases.
Function

What it Does

When to Use It

around_transaction

Wraps the entire

Use to manage

transaction, enabling

transaction-level

control over its lifecycle.

concerns, such as custom
transaction handling or
monitoring.

before_transaction

Runs before a transaction

Use to set up data or

starts, preparing data or

enforce prerequisites

checking preconditions.

before the transaction
begins.

around_action

Wraps the entire action,

Use for tasks like logging

allowing setup and

execution time or

teardown tasks.

managing action-wide
resources.

106

Function

What it Does

When to Use It

before_action

Executes before the

Use to validate inputs or

action’s core logic,

add data to the changeset

modifying the changeset

that affects what is stored

or performing validations. in the database.
after_action

Runs after the action

Use to trigger side effects,

completes successfully,

such as sending

handling side effects.

notifications or updating
related resources.

after_transaction

Executes after the

Use for cleanup tasks or

transaction completes,

logging transaction

regardless of success or

outcomes.

failure.
Here, we will focus on two of the most commonly used callbacks: before_action
and after_action for :read and :create action types separately. The most
important thing to understand is the function signature of these callbacks, as they
differ for different action types. We explain these with an example in the following
sections.

7.1. How to Define before_action for a Read Action?
Dev Story
Chaaru is working on a feature to list all comments in Tuesday,
where data follows this hierarchy: an Organization has many
Projects, a Project has many Tasks, and a Task has many
Comments. An actor is an OrganizationMember who may or may
not be part of various Projects. Chaaru wants to filter comments
based on user input, either showing all comments in the actor’s
organization or only those in projects where the actor is a member.
Chaaru aims to dynamically adjust the read query’s filter based on user input. In
Tuesday, we have defined an action in the Comment resource to address this:

107

lib/tuesday/projects/comment.ex
defmodule Tuesday.Projects.Comment do
actions do
read :list_filtered_comments_before_callback do
argument :filter_level, :atom, default: :organization,
constraints: [one_of: [:project, :organization]]
prepare before_action fn query, context ->
filter_level = Ash.Query.get_argument(query, :filter_level)
do_filter_comments(query, context.actor, filter_level)
end
end
end
end

This

action

uses

the

filter_level

argument

to

determine

the

filter:

:organization returns all comments in the actor’s organization, while :project
returns comments from projects where the actor is a member.
We achieve this using the prepare DSL in the read action, specifying a
before_action callback:
prepare before_action fn query, context -> query end

The before_action callback’s anonymous function takes the following inputs:
• query: An Ash.Query struct containing filters, sorts, and field selections for the
action,

modifiable

with

functions

like

Ash.Query.filter/2,

Ash.Query.sort/2, or Ash.Query.limit/2.
• context: An Ash.Resource.Preparation.Context struct with keys actor,
tenant, authorize?, and tracer, populated from options passed to
Ash.Query.for_read/4.
The callback must return a modified or unmodified Ash.Query, which Ash
executes against the data layer. Everything else we do in the anonymous function is
implementation details. In the example above, we retrieve the filter_level
argument inside the callback function and call a private function to modify the
query:

108

prepare before_action fn query, context ->
filter_level = Ash.Query.get_argument(query, :filter_level)
do_filter_comments(query, context.actor, filter_level)
end

For completeness, we include the private functions in the Comment resource that
handle query modification as well as IEx execution/outputs below:

lib/tuesday/projects/comment.ex
defmodule Tuesday.Projects.Comment do
defp do_filter_comments(query, %{organization_id: actor_org_id},
:organization) when not is_nil(actor_org_id) do
org_filter_expr = [task: [project: [organization_id: actor_org_id]]]
Ash.Query.filter(query, ^org_filter_expr)
end
defp do_filter_comments(query, %{id: actor_id}, :project) when not
is_nil(actor_id) do
project_filter_expr = [task: [project: [project_members:
[organization_member: [id: actor_id]]]]]
Ash.Query.filter(query, ^project_filter_expr)
end
end

iex> actor = Tuesday.Workspace.OrganizationMember |> Ash.
read_first!(authorize?: false)
iex> (Tuesday.Projects.Comment
|> Ash.Query.for_read(:list_filtered_comments_before_callback,
%{filter_level: :project}, actor: actor, authorize?: false)
|> Ash.read!()
|> Enum.count())
92
iex> (Tuesday.Projects.Comment
|> Ash.Query.for_read(:list_filtered_comments_before_callback,
%{filter_level: :organization}, actor: actor, authorize?: false)
|> Ash.read!()
|> Enum.count())
167

The action list_filtered_comments_before_callback returns different record

109

counts based on the filter_level, demonstrating the before_action callback’s
dynamic query modification. The above highlighted numbers may differ from what
you see on your machine as the seed data is randomized. == How to Define
before_action for a Create Action?

Dev Story
Chaaru is working on the Comment resource in Tuesday and
encounters a specific feature request. The product owner doesn’t
want comment text to contain any emoji shorthand (example,
":heart:") and wants them all to be automatically replaced with
emoji before being inserted into the database. For example, if a
user inputs Hello :heart:, the comment should be stored as
Hello emoji.
Scenarios like this, where we want to transform the user input just before the
actual update of the data in the database, are a perfect use case for
before_action. We do not want to do this extra work unless everything else is
valid with the changeset and we are at the last step to insert the record.
In Tuesday, we defined an action in Comment resource to demonstrate this ask:

lib/tuesday/projects/comment.ex
defmodule Tuesday.Projects.Comment do
actions do
create :create do
accept [:body, :task_id]
change before_action fn changeset, _context ->
text = Ash.Changeset.get_attribute(changeset, :body)
transformed_text = transform_emoji(text)
Ash.Changeset.change_attribute(changeset, :body,
transformed_text)
end
end
end
end

110

This action processes the :body attribute in the changeset, transforming emoji
shorthand before saving the comment.
We achieve this using the change macro in the create action, specifying a
before_action callback. The anonymous callback function passed to the callback
has the following signature:
change before_action fn changeset, context -> updated_changeset end

The callback function takes the following two inputs:
• changeset: An Ash.Changeset struct containing the data and attributes for the
create

action,

modifiable

with

functions

like
or

Ash.Changeset.force_change_attribute/3
Ash.Changeset.change_attribute/3.

• context: An Ash.Resource.Change.Context struct with keys actor, tenant,
authorize?, tracer, and bulk?, populated from options passed to
Ash.Changeset.for_create/4.
The callback function must return a changeset, which may or may not be modified
depending on the business context. Ash uses this changeset to persist the data to the
data layer. In the example above, we fetch the body attribute from the changeset,
transform this text, and update the body attribute of the changeset with the
updated content.
For completeness, we include a private function in the Comment resource that
handles the emoji transformation:

lib/tuesday/projects/comment.ex
defmodule Tuesday.Projects.Comment do
defp transform_emoji(text) do
text
|> String.replace(":heart:", "**emoji**")
|> String.replace(":smile:", "**emoji**") # Add more emoji mappings
as needed
end
end

111

Let’s try this in action in the IEx shell:
iex> actor = Ash.read_first!(OrganizationMember, authorize?: false)
iex> task = Ash.read_first!(Task, authorize?: false)
iex> params = %{body: "Hello :heart: :smile:", task_id: task.id}
iex> opts = [actor: actor, authorize?: false]
iex> (comment = Tuesday.Projects.Comment
|> Ash.Changeset.for_create(:create_comment, params, opts)
|> Ash.create!())
#Tuesday.Projects.Comment<
id: "1763a421-f2f5-41d3-9e07-c82d8c3d3e8c",
body: "Hello **emoji** **emoji**",

The action create_comment successfully transforms the emoji shorthand,
demonstrating that our before_action callback is at work before inserting the
comment into the database. == How to Define after_action for a Read Action?

Dev Story
Chaaru is working on a feature in Tuesday to maintain a list of the
last five projects visited by a user. Each time a user reads a project,
the system should update the actor’s list of the last five viewed
projects.
Chaaru aims to update the actor’s list of recently visited projects after a read action
is executed. In Tuesday, we have defined a simple Elixir Agent that can work as a
simple key-value store for us to record the actor history. It has two simple APIs to
record the history of a user and to retrieve the history of a user.
We can quickly play with it in IEx:
# To record User ID: "USER:1" viewed Project ID: "ID:100"
iex> Tuesday.ProjectViewHistory.view_project("USER:1", "ID:100")
:ok
# To view the history of User ID: 1
iex> Tuesday.ProjectViewHistory.get_viewed_projects("USER:1")
["ID:100"]

112

With this key-value store working, we only want a simple way to hook this up
whenever someone reads a project record. We have defined an action in the
Project resource to demonstrate this requirement:

lib/tuesday/projects/project.ex
defmodule Tuesday.Projects.Project do
actions do
read :read_with_history do
argument :id, :uuid, allow_nil?: false
get? true
filter expr(id == ^arg(:id))
prepare after_action fn _query, [record], context ->
Tuesday.ProjectViewHistory.view_project(context.actor.id,
record.id)
{:ok, [record]}
when _query, records, _context -> {:ok, records}
end
end
end
end

This action updates the actor’s project history in the key-value store after retrieving
a project by its ID.
We achieve this using the after_action hook in the read action, specifying a
callback:
prepare after_action fn query, records, context -> {:ok, records} end

The after_action callback’s anonymous function has this specific signature.
It takes three arguments as explained below:
• query: An Ash.Query struct containing the filters, sorts, and field selections for
the action that has been used to get the records.
• records: A list of records returned by the read action, which can be modified if
needed.

113

• context: An Ash.Resource.Preparation.Context struct with keys actor,
tenant, authorize?, and tracer, populated from options passed to
Ash.read/2.
It must return {:ok, records}, where records is the list of records (modified or
unmodified) to be returned to the caller. The callback must always return a list.
It’s important to note that records is a list even if get? true is
configured on the action to fetch a single record. The records list
may be empty as well, and hence it’s important to ensure any
pattern matching we do on the structure of the list also takes into
account the possibility of an empty list. In Tuesday, we have two
matching function heads in the anonymous function to account for
this situation.
Let’s verify the callback in IEx:
# Verify the actor's viewed history is empty
iex> actor = Tuesday.Workspace.OrganizationMember |> Ash.
read_first!(authorize?: false)
iex> Tuesday.ProjectViewHistory.get_viewed_projects(actor.id)
[]
# Simulate reading a project for the actor
iex> opts = [actor: actor, tenant: actor.organization_id, authorize?:
false]
iex> project = Tuesday.Projects.Project |> Ash.read_first!(authorize?:
false)
iex> (Tuesday.Projects.Project
|> Ash.Query.for_read(:read_with_history, %{id: project.id}, opts)
|> Ash.read!())
# Verify that the actor's history is indeed recorded
iex> Tuesday.ProjectViewHistory.get_viewed_projects(actor.id)
["300c2802-b15b-40e7-adf2-2cd7b156e71b"]

As we can see, when a project is read with the read_with_history action, the
agent ProjectViewHistory updates the view history for the actor. For this

114

demonstration, we have used a simple Agent to manage the history, but you may
want to use any appropriate mechanism to store and retrieve the history.

7.2. How to Define after_action for a Create Action?
Dev Story
Chaaru is working on a feature in Tuesday to create an audit log for
all created projects. For simplicity, she just wants to use a simple
Logger.info call whenever a new project is created.
In Tuesday, we have defined a create action named create_with_audit to
demonstrate this functionality. Later in the book, we explain how to do similar
logging using Ash Notifier, which is simpler to set up and more robust.

lib/tuesday/projects/project.ex
defmodule Tuesday.Projects.Project do
actions do
create :create_with_audit do
accept [:name, :organization_id]
change after_action fn changeset, result, context ->
require Logger
Logger.info("Actor: #{context.actor.id} created project:
#{result.id}")
{:ok, result}
end
end
end
end

We achieve this using the after_action hook in the create action, specifying a
callback:
after_action fn changeset, result, context -> {:ok, result} end

The after_action callback’s anonymous function has a specific signature.

115

It takes the following as input:
• changeset: An Ash.Changeset struct containing the input data and attributes
used for the create action.
• result: Since the after_action callback is called only on successful insert,
update, or delete, it contains only the successful record from the data layer.
• context: An Ash.Resource.Change.Context struct with keys actor, tenant,
authorize?, tracer, and bulk?, populated from options passed to
Ash.Changeset.for_create/4.
params = %{name: "New Project", organization_id: org_id}
opts = [actor: actor, tenant: org_id]
Tuesday.Projects.Project
|> Ash.Changeset.for_create(:create_with_audit, params, opts)
|> Ash.create()

While actor can be set either when calling Ash.create or while
creating the Ash.Changeset in most cases without issue, for
actions that make use of callbacks, setting the actor or any other
context value that the callback function depends on should be set
while creating the changeset. Setting them only when calling
Ash.create will not pass these contexts to the callbacks and will
result in callbacks getting an empty actor or other context variables
that we might depend on in the callback functions.
The callback must return the create action’s result, either {:ok, record} or
{:error, error}.
Let’s verify if this action callback works in the IEx shell:
iex> actor = Tuesday.Workspace.OrganizationMember |> Ash.
read_first!(authorize?: false)
#Tuesday.Workspace.OrganizationMember<
id: "72482880-bfae-4148-a652-e6370f0b50ed",
...

116

>
iex> params = %{name: "ProjectLog", organization_id: org_id}
iex> opts = [actor: actor, authorize?: false]
iex> (Tuesday.Projects.Project
|> Ash.Changeset.for_create(:create_with_audit, params, opts)
|> Ash.create())
[info] Actor: 72482880-bfae-4148-a652-e6370f0b50ed created project:
0f8c823d-0ebf-40ad-a344-39a593b9682c

As we can see in the highlighted lines above, our Logger.info has been called with
the actor ID and the created project ID.

7.3. Summary
The

chapter

investigated

Ash

Action

lifecycle

callbacks,

focusing

on

before_action and after_action for read and create actions, using the
Tuesday application’s Comment and Project resources as examples. Below are the
key concepts covered.

7.3.1. Key Concepts
• Purpose of Callbacks: Action lifecycle callbacks are hooks that inject custom
logic at specific points in an action’s execution, akin to Rails’ before_save or
Django’s

pre_save.

They

support

tasks

like

input

validation,

data

transformation, or side effects (e.g., logging, notifications).
• Before and After Action for Read: In a read action, the prepare
before_action callback modifies an Ash.Query struct (e.g., dynamically
filtering comments by organization or project membership) using query and
context as inputs, while the prepare after_action callback handles postexecution side effects (e.g., tracking viewed projects in a user’s history), taking
query, records (a list), and context, and returning {:ok, records}, with
pattern matching to accommodate varying list sizes.
• Before and After Action for Create: In a create action, the change
before_action callback modifies an Ash.Changeset struct (e.g., replacing
emoji shorthand in comment text) using changeset and context as inputs,
returning

an

updated

changeset

for

persistence,

while

the

change

117

after_action callback handles post-creation side effects (e.g., logging project
creation), taking changeset, result (the created record), and context, and
returning {:ok, result} or {:error, error}.
• Callback Configuration: Context values like actor must be set during
Ash.Changeset or Ash.Query creation to ensure availability in callbacks, as
setting them only in Ash.create or Ash.read may lead to empty context.
Callbacks require specific return types to maintain action flow.

118

Chapter 8. Code Interface

8.1. What is a code interface and how do I define one in Ash?
Dev Story
Chaaru is satisfied with the action definitions in Tuesday’s
resources. These actions clearly capture the business intent, and
reading the resource files feels like reviewing well-written
documentation of the project’s functionality. She appreciates Ash’s
capabilities but is frustrated by the verbose nature of calling actions
and the redundancy she feels when writing functions to perform
them. Surely, there must be an easier way to call these actions, she
wonders!
How does Chaaru use actions in his code? For example, how does she invoke the
action to create a new project, defined as shown below in the Project resource?
create :create_project do
description "Creates a new project."
accept [:name, :description, :start_date, :end_date, :organization_id]
validate present(:name), message: "is required"
validate present(:end_date), message: "is required"
validate present(:organization_id), message: "is required"
end

As we saw earlier, an Action in Ash is still the intent of what you want to do. It’s just
data. It doesn’t actually perform the action of making changes in the data store. To
do that we need to create a Ash Changeset (if it’s a create/update/delete action) or
an Ash Query (if it’s a read action) and pass it with necessary user params to one of
the

four

CRUD

functions

in

Ash,

namely

Ash.create/3,

Ash.read/2,

Ash.update/3 or Ash.destroy/2

119

Currently, if we want to create a project, we do so like below:
iex> Ash.create(Tuesday.Projects.Project, %{name: "Some Project"},
action: :create)

This becomes quite redundant as we have to pass in the module name and the
action name each time. This is even more evident when it comes to calling these
actions from the controller.
For example, we could possibly have the following code in our Phoenix controller
to create and update a project when using Ash:
alias Tuesday.Projects
def create(conn, %{"project" => project_params}) do
result = Tuesday.Projects.Project
|> Ash.create(project_params, action: :create_project)
case result do
# Do something with the result
...
end
end
def update(conn, %{"id" => id, "project" => project_params}) do
project = Ash.get!(Tuesday.Projects.Project, id)
result = project
|> Ash.update(project_params, action: :update_project)
case result do
# Do something with the result
...
end
end

In vanilla Phoenix, we get a nice wrapper function from Phoenix Context modules
like Projects.create_project/1 or Projects.update_project/2 which hides
away the internal implementations as shown below:

120

alias Tuesday.Projects
def create(conn, %{"project" => project_params}) do
case Projects.create_project(project_params) do
# Do something with the result
end
end
def update(conn, %{"id" => id, "project" => project_params}) do
project = Projects.get_project!(id)
case Projects.update_project(project, project_params) do
# Do something with the result
end
end

There is nothing that stops us from defining such wrapper functions in our
Tuesday.Projects domain. Ash Domains are regular Elixir modules and we could
define the following functions in them to mimic what we would do with Phoenix
Contexts.

8.2. Creating Domain Code Interface Manually
One possible way to create wrapper functions in Tuesday.Projects is to define
functions direction on our Domain modules as shown below:
alias Tuesday.Projects
def get_project(id), do: Ash.get!(Tuesday.Projects.Project, id)
def create_project(project_params) do
Tuesday.Projects.Project
|> Ash.create(project_params, action: :create_project)
end
def update_project(project, project_params) do
project
|> Ash.update(project_params, action: :update_project)

121

end

With these additions, we can now use these functions the same way as Phoenix
Context functions in vanilla Phoenix.
Remember, we are using Ash! The core philosophy is "model your
domain, derive the rest". Ash doesn’t want us to duplicate efforts. So
there is a better way to define these functions in the domain
module and the answer is Ash Code Interface feature.

8.3. Creating Domain Code Interface Automatically
Code interfaces are a way to define functions that interace with the rest of our
application connecting them to the different actions we have already defined in the
resources.

Instead

of

writing

those

two

functions

manualy

inside

the

Tuesday.Projects domain, We can make Ash define this function for us by
defining code interface in the domain module as shown below:

lib/tuesday/projects.ex
defmodule Tuesday.Projects do
use Ash.Domain, ...
resources do
resource Tuesday.Projects.Project do
define :create_project
define :update_project
...
end
end
end

To define a code interface, we begin by adding a do-end block to our resource
macro for which we are defining the code interface. Within the do-end block, we
call the define macro, with the first argument being the name of the code interface
or simply the name of the function we want Ash to generate for us. In our case, the

122

function

name

is

create_project,

which

matches

the

action

name

create_project, so we can omit the second argument. If the function name and
the action name linked to this function differ, we pass the action name in a
keyword list along with other optional configurations. For example, if our action
name defined in Project is my_custom_action and we want the function to be
named do_awesome_stuff, our code interface would look like this:
resources do
resource Tuesday.Projects.Project do
define :do_awesome_stuff, action: :my_custom_action
...
end
end

Once our code interface is defined and our project is recompiled, we can use the
code interface like below:
iex>

h Tuesday.Projects.create_project
def create_project(params \\ nil, opts \\ nil)

Creates a new project.
# Inputs
• name
• description
• organization_id
• start_date
• end_date
## Options
• :upsert? (t:boolean/0) - If a conflict is found based on the primary
key, the record is updated in the database (requires upsert support)
The
default value is false.
• :return_skipped_upsert? (t:boolean/0) - If true, and a record was
not
upserted because its filter prevented the upsert, the original
record
(which was not upserted) will be returned. The default value is
false.

123

....

As you can see above, all the documentaion is generated by Ash as we didn’t write
any of them. It is important to note that Ash creates two variations: One which
returns a tuple (create_project) and the one that returns the record directly or
"raises an error" (create_project!)
Ash defines functions with a can_ prefix for all configured code
interfaces. For example, for a code interface for :create_project,
Ash defines can_create_project?. These functions return a
boolean indicating whether the actor passed to the function is
allowed to perform the action. They use Ash policies to perform
these checks. We cover policies later in the book, and we use these
can_? functions extensively in Tuesday’s test suite for policy
testing.
Then, we can actually use the code interfaces as illustrated below:
iex> org = Organization |> Ash.read_first!(authorize?: false)
iex> proj_params = %{name: "Project1", end_date: Date.utc_today(),
organization_id: org.id}
iex> Projects.create_project(proj_params, authorize?: false)
{:ok,
#Tuesday.Projects.Project<
...

8.4. Defining Code Interface Function On Resource
It is also possible for us to define a code interface to get a single record by a field
name. Below is how we can define a code interface in order to retrieve a record by
it’s ID:

lib/tuesday/accounts.ex
resources do
resource Tuesday.Accounts.Organization do

124

...
define :get_organization, action: :read, get_by: :id
end
end

As you can see on the above code snippet, we’ve used the get_by option with the
value :id. We can also get a record by any other field name as well.
We can also define code interface functions in the resource module. While the
format for defining a code interface is the same in both domains and resources,
there is a slight difference in how they are defined. In resources, we define them
inside a code_interface do…end block, like this:
defmodule App.Domain.Resource do
...
code_interface do
define :code_interface_name, action: :action_name
end
end

The functions are generated on the resource module which we can call like below:
iex> h App.Domain.Resource.code_interface_name
iex> h App.Domain.Resource.code_interface_name!

8.5. Summary
The chapter explored the Ash Code Interface, a feature that simplifies calling
actions by generating wrapper functions, as demonstrated with the Tuesday
application’s Project and Organization resources. Below are the key concepts
covered.

8.5.1. Key Concepts
• Purpose of Code Interface: The Code Interface reduces verbosity and
redundancy in calling Ash actions (e.g., Ash.create/3, Ash.read/2) by
generating

wrapper

functions

that

mimic

Phoenix

Context

functions,

encapsulating action logic for cleaner application code.

125

• Defining Code Interfaces: Code interfaces are defined in an Ash Domain or
Resource module. In a Domain, they are specified within a resources block
using the define macro (e.g., define :create_project), linking to an action
(defaults to the same name or specified via action: :action_name). In a
Resource, they are defined in a code_interface block with the same define
syntax.
• Generated Functions: Ash generates two function variants for each code
interface: a safe version returning a tuple (e.g., create_project/2 returns
{:ok, record} or {:error, error}) and a bang version that raises on error
(e.g., create_project!/2). Documentation is auto-generated, detailing inputs
and options (e.g., :upsert?, :return_skipped_upsert?).

126

Chapter 9. Relationships

9.1. What is a Resource Relationship?
Resource relationships define how the current resource is related to other
resources in our application. There are four kinds of relationships that we can
define with Ash:
1. belongs_to
2. has_one
3. has_many
4. many_to_many
All kinds of relationships are defined under the relationships block in the
Resource module:
defmodule SomeResource do
...
relationships do
# All relationship definitions go here
end
end

9.2. How to Define a belongs_to Relationship?
Dev Story
Chaaru wants to define a relationship between the Task and
Project resources in Tuesday. She is familiar with belongs_to
associations from other frameworks and has reviewed the
belongs_to macro documentation in Ash. While it seems
straightforward, she wants to understand Ash’s internal mechanics
and the customization options available for the belongs_to
relationship.

127

At the database level, Chaaru understands that the tasks table includes a foreign
key referencing the projects table to ensure valid project references. She also
knows that the project_id column in the tasks table must be mandatory to
prevent task creation without a project_id. Let’s explore how this is implemented
in Ash.
We need to define a relationship name at the application level, which translates to a
column name at the database level. We also need to define the target resource
identified by the relationship, which translates to the referenced table at the
database level.
So essentially, we are looking at how to map these four things in Tuesday.
Application Level

Database Level

Relationship Name

Column Name

Target Resource

Referenced Table

Below is a snippet from the Task resource defining this relationship:

lib/tuesday/assignments/task.ex
defmodule Tuesday.Assignments.Task do
relationships do
belongs_to :project, Tuesday.Workspace.Project
end
end

To define a belongs_to relationship, we use a relationships block in the
resource and call the belongs_to macro with two arguments:
• The name of the relationship, e.g., :project.
• The target resource module, e.g., Tuesday.Workspace.Project.
This fulfills the application-level requirements. The belongs_to macro creates a
project_id attribute in the Task resource, which automatically generates a
project_id column in the tasks table. Ash automatically references the

128

projects table, inferring it from the Tuesday.Workspace.Project resource.
However, Ash makes the following assumptions:
• Source table: The column in tasks is named project_id referencing the
projects table.
• Destination table: The referenced column in projects is id.
• Nullability: The project_id column allows null values.
These defaults simplify configuration but can be overridden if they don’t match our
business needs. Let’s look at some common options used with belongs_to. To
customize, we add a do-end block to the belongs_to macro:
defmodule Tuesday.Assignments.Task do
relationships do
belongs_to :project, Tuesday.Workspace.Project do
source_attribute :project_id
destination_attribute :id
allow_nil? false
public? true
end
end
end

We’ve used four options:
source_attribute :project_id
Specifies the attribute and column name as project_id. This is redundant here
since the default is :<relationship_name>_id (i.e., project_id), but useful
when a different name is needed.
destination_attribute :id
Defines the referenced attribute in Project. The default is id, so this is optional
unless the primary key differs (example: ref_id).
allow_nil? false
Ensures the project_id is mandatory, preventing task creation without a
project. The default is true.

129

public? true
Exposes the relationship in JSON and GraphQL APIs. See Ash documentation for
more options.

Dev Story
In Tuesday, some belongs_to relationships require custom
configurations. For example, the TaskAssignee resource relates to
OrganizationMember, but Chaaru wants the relationship named
:assignee to reflect business terminology (“a task is assigned to
someone”) rather than “belongs to an organization member.”
Additionally, while the application uses assignee_id as the
attribute

name,

the

database

column

should

be

organization_member_id for clarity in technical contexts.
This allows database administrators or data scientists to work with
the data without needing to understand the specific domain
language used in the application.
We could have done this on the TaskAssignee module to define the relationship.
belongs_to :assignee, Tuesday.Workspace.OrganizationMember

However, this creates both attribute and column name as assignee_id, which
doesn’t meet the database naming requirement. To address this, we configure the
TaskAssignee resource as follows:
defmodule Tuesday.Projects.TaskAssignee do
...
attributes do
attribute :assignee_id, :uuid do
source :organization_member_id
end
end
relationships do
belongs_to :assignee, Tuesday.Workspace.OrganizationMember do

130

define_attribute? false
source_attribute :assignee_id
end
...
end
end

In the relationships block:
1. The relationship is named :assignee
2. Explicitly disabled automatic attribute creation with define_attribute?
false
3. Finally, set source_attribute :assignee_id for the relationship explicitly.
And then in the attributes block:
1. The assignee_id attribute is defined as usual as any other attribute
2. Added source :organization_member_id to name the database column
organization_member_id.
Voilà! With both these configurations, we have configured everything as per our
needs in an elegant way using Ash macros.

9.3. How to Define a has_many Relationship?
Dev Story
Having defined the belongs_to relationship, Chaaru now wants to
define the other side of the relationship, which is has_many. She
understands that it must be a straightforward thing to do in Ash.
Through experience, she knows that every application that needs
has_many relationships always wants them in a specific order. For
example, Tuesday doesn’t need a list of all organization members in
random order but needs it in a specific order, such as alphabetical
or last updated.

131

Like the belongs_to macro, has_many supports several options to meet Chaaru’s
needs, but first, let’s explore how to define a basic has_many relationship.
The syntax for a has_many relationship is similar to belongs_to:
defmodule Tuesday.Workspace.Organization do
relationships do
has_many :members, Tuesday.Workspace.OrganizationMember
end
end

The

relationship

is

named

:members,

and

the

related

resource

is

Tuesday.Workspace.OrganizationMember. As with belongs_to, the has_many
macro makes assumptions about the underlying attributes and database structure:
• Source table: The column in the organizations table referenced by
organization_members is id.
• Destination

table:

The

column

in

the

organization_members

table

referencing organizations is organization_id.
To customize these defaults and address sorting requirements, we use a do-end
block with the has_many macro:
defmodule Tuesday.Workspace.Organization do
relationships do
has_many :members, Tuesday.Workspace.OrganizationMember do
source_attribute :id
destination_attribute :organization_id
sort [username: :asc]
end
end
end

We use three options:
source_attribute :id
Specifies the attribute in the Organization resource referenced by the related

132

resource. The default is :id, making this optional here but useful if the primary
key differs (example: ref_id).
destination_attribute :organization_id
Defines

the

foreign

key

in

OrganizationMember.

The

default

is
(i.e.,

:<lowercase_final_segment_of_source_module>_id
organization_id), so this is optional unless the foreign key differs.
sort [username: :asc]

Orders the related records by the specified attribute and sort direction.
Supported sort orders are:
• :asc
• :desc
• :asc_nils_first
• :asc_nils_last
• :desc_nils_first
• :desc_nils_last
Multiple

sort

orders

can

be

specified

like

[username:

:asc,

inserted_at: :desc].
While we’ve only shown a handful of common options, we can look at other options
in the Ash documentation.
Since the default source_attribute and destination_attribute match our
needs already, we can simplify the configuration to include only the sort option:
defmodule Tuesday.Workspace.Organization do
relationships do
has_many :members, Tuesday.Workspace.OrganizationMember do
sort [username: :asc]
end
end
end

133

9.4. How to Define has_one Using has_many Relation?
Dev Story
Chaaru has a special requirement in Tuesday. She is asked to show
one latest comment per task when displaying the tasks. She can use
the existing relationship of Task has_many comments, but that
fetches all the comments when she only needs to show the latest
one.
The has_one relationship is defined just like how has_many is defined. All the
options of has_many are also applicable to has_one. Nevertheless, there’s one
additional option for has_one that we can use in our Task resource to meet
Chaaru’s needs—and that is from_many?: true.
This option is useful whenever we want to get only the top record from a list of
records. Below is an example where we get the latest comment of a task:

lib/tuesday/assignments/task.ex
has_one :latest_comment, Tuesday.Assignments.Comment do
from_many? true
sort [inserted_at: :desc]
end

Note that we’ve used the sort option to sort the comments in descending order of
the inserted_at attribute. This way, we get the latest comment.
Defining a has_one relationship using the from_many?: true
option is quite different from the first aggregate, which we will
see later in the Aggregates chapter. The first aggregate can only
retrieve an attribute from a relationship. However, with the
has_one option, we can retrieve the entire first record from the list.

134

9.5. How to Define a many_to_many Relationship?
Dev Story
Chaaru, having defined belongs_to and has_many relationships,
now wants to define a many_to_many relationship in Tuesday. She
needs to associate OrganizationMember with multiple Projects,
and

each

project

with

multiple

members,

reflecting

team

assignments. She expects this to be straightforward in Ash but
wants to understand the mechanics and customization options for
the many_to_many relationship.
Like the has_many macro, many_to_many supports several options to meet
Chaaru’s needs, but first, let’s explore how to define a basic many_to_many
relationship.
The syntax for a many_to_many relationship involves specifying a join resource to
manage the associations:
defmodule Tuesday.Workspace.OrganizationMember do
relationships do
many_to_many :projects, Tuesday.Projects.Project do
through Tuesday.Projects.ProjectMember
end
end
end

The relationship is named :projects, and the related resource is
Tuesday.Projects.Project. Unlike belongs_to or has_many, the
many_to_many macro requires a join resource
(Tuesday.Projects.ProjectMember) to handle the many-to-many association.
Ash makes assumptions about the underlying attributes and database structure:
• Join table: The project_members table has foreign keys referencing both
organization_members and projects.
• Source

table:

The

column

in

organization_members

referenced

by

project_members is id.

135

• Destination table: The column in projects referenced by project_members is
id.
To customize these defaults and add metadata, we use a do-end block with the
many_to_many macro:
defmodule Tuesday.Workspace.OrganizationMember do
relationships do
many_to_many :projects, Tuesday.Projects.Project do
description "Projects assigned to this member."
through Tuesday.Projects.ProjectMember
source_attribute_on_join_resource :organization_member_id
destination_attribute_on_join_resource :project_id
end
end
end

We use three options:
• through

Tuesday.Projects.ProjectMember: Specifies the join resource

managing the association, required for many_to_many relationships.
• source_attribute_on_join_resource

:organization_member_id:

Defines the foreign key in ProjectMember referencing OrganizationMember.
The

default

is

:<lowercase_source_module>_id

(i.e.,

organization_member_id), so this is optional here.
• destination_attribute_on_join_resource
foreign

key

in

ProjectMember

referencing

:<lowercase_destination_module>_id

(i.e.,

:project_id: Defines the
Project.

The

project_id),

default

is

so

is

this

optional unless the foreign key differs.
The join resource, ProjectMember, must define corresponding belongs_to
relationships to complete the association:

lib/tuesday/projects/project_member.ex
defmodule Tuesday.Projects.ProjectMember do
relationships do
belongs_to :organization_member,

136

Tuesday.Workspace.OrganizationMember, allow_nil?: false
belongs_to :project, Tuesday.Projects.Project, allow_nil?: false
end
end

This

ensures

the

project_members

table

has

non-nullable

foreign

keys

(organization_member_id and project_id) linking OrganizationMember and
Project.
Since

the

default

source_attribute_on_join_resource

and

destination_attribute_on_join_resource match our needs, we can simplify
the configuration, retaining only the required through option and optional
description:
defmodule Tuesday.Workspace.OrganizationMember do
relationships do
many_to_many :projects, Tuesday.Projects.Project do
description "Projects assigned to this member."
through Tuesday.Projects.ProjectMember
end
end
end

See Ash documentation for additional options, such as sort for ordering related
records.

9.6. How Do We Define a Self-Referencing Relationship in Ash?
Dev Story
Tuesday has the requirement to allow a task to have multiple
subtasks, and Chaaru is looking at how to model this relationship.
This can be achieved using self-referential relationships, which are similar to what
we have seen earlier with has_many and belongs_to, except that both the source
and the destination resource are the same.

137

lib/tuesday/assignments/task.ex
relationships do
belongs_to :parent_task, __MODULE__
has_many :sub_tasks, __MODULE__ do
destination_attribute :parent_task_id
end
...
end

We start to define a self-referencing relationship by defining a belongs_to
relationship. As we see in the above code snippet, we’ve defined a belongs_to
relationship called parent_task, and the resource module is the current module
itself. This would generate an attribute called parent_task_id in our resource
relating to its own resource.
Next, we define a has_many relationship called sub_tasks. We may recall that the
default

value

of

the

option

destination_attribute

is

<snake_case_final_segment_of_module>_id, which would become task_id in
our case. But we want it to be parent_task_id, and hence we’ve set it explicitly.
With this setup, we now have everything set up for managing a self-referential
relationship!

9.7. How Do We Create a Relationship Without a Foreign Key?
Dev Story
Chaaru meets a requirement in Tuesday that says when a user is
viewing a single task in detail from Project A, they also need to see
other tasks from Project A alone as a list of titles.
Expressed as SQL, this requirement is as follows:
SELECT title
FROM tasks
WHERE project_id = (SELECT project_id FROM tasks WHERE id =
:current_task_id)

138

AND id != :current_task_id;

This query is neither self-referential as in defining subtasks nor does it use a
regular foreign key to list the associated records.
Generally, relationships are created using foreign keys. In Ash, it is possible to
create relationships without foreign keys that can express an SQL query like the
above. There’s already a relationship between task and project that is created
normally using foreign keys. Let’s now create a relationship between a task and
other tasks part of the same project:
has_many :related_project_tasks, Tuesday.Assignments.Task do
no_attributes? true
filter expr(project_id == parent(project_id))
filter expr(id != parent(id))
end

So, inside the relationship, we’ve used the no_attributes? option with the value
true. This means that we are creating a relationship without a foreign key. We’ve
also used two filters below. In both these filters, we’ve used the parent function in
our expressions. It is used to refer to the attribute of the current resource from
which the relationship is being created. Think of parent as the record that is
currently being viewed in detail for which we want to list the related project tasks.
In the first filter, we are checking if the project_id in the relationship is the same
as the project_id of the current task, and we do so by using the function parent.
This ensures that we’re getting tasks that are part of the same project. In the second
filter, we’re checking if the id of the task in the relationship is not the same as the
id of the current task. This ensures that we’re not getting the same task that is
being viewed in the related records.

9.8. How Do We Define a Manual Relationship?
Dev Story
Tuesday needs a feature to track only the most critical progress
within each project—specifically, tasks that are both high priority

139

and not completed. The existing has_many :tasks relationship in
the Project resource shows all tasks, cluttering the view and making
it hard to focus. Chaaru can define filters in the relationships as she
has done with completed_tasks, but is there an alternative?
We can define a manual relationship for complex and non-typical use cases. The
Ash documentation suggests that we use manual relationships sparingly, as we
can do a lot with filters on relationships, and the no_attributes? flag. In fact,
this is true with Tuesday’s requirement. Chaaru can use filter to get this job done.
However, let’s use this as an opportunity to learn how to define a manual
relationship. Let’s create a new relationship in our Project resource called
high_priority_incomplete_tasks and configure it as manual as shown below:

lib/tuesday/projects/task.ex
alias Tuesday.Projects.HighPriorityIncompleteTasks
has_many :high_priority_incomplete_tasks, Tuesday.Assignments.Task do
manual {HighPriorityIncompleteTasks, threshold: 3}
end

In the above code, we start off by having a has_many relationship with the name
:high_priority_incomplete_tasks

and

the

resource

module

Tuesday.Assignments.Task. This means it is related to many tasks. We define a
manual relationship by setting the manual option and provide the module that
implements the relationship query. It’s actually the manual implementation that
makes it a manual relationship. Taking that into consideration, we could also make
any relationship into a manual relationship.
In

our

case,

the

module

that

contains

the

manual

Tuesday.Projects.HighPriorityIncompleteTasks.

implementation

This

module

is

should

implement the Ash.Relationship behaviour. In the module, we need to define the
load function. Let’s see how we can define the module:

lib/tuesday/projects/task/high_priority_incomplete_tasks.ex
defmodule Tuesday.Projects.HighPriorityIncompleteTasks do
use Ash.Resource.ManualRelationship

140

require Ash.Query # We need to use Ash.Query to filter the records
def load(projects, opts, %{query: query} = context) do
project_ids = Enum.map(projects, & &1.id)
{:ok,
query
|> Ash.Query.filter(project_id in ^project_ids)
|> Ash.Query.filter(is_complete: false)
|> Ash.Query.filter(priority: [lesser_than: 3])
# Let’s pass the context back to opts for Ash.read!
|> Ash.read!(Ash.Context.to_opts(context))
|> Enum.group_by(& &1.project_id)}
end
end

The load function has three arguments:
1. records: The records of the parent resource where the relationship is defined.
In our case, we refer to them as projects.
2. opts: The options that are passed to the manual relationship configuration
3. context: The context map that contains the base query for the related data that
can be modified to fetch the related data as needed
By default, the context contains the query to be made for the relationship. We’ve
used it to extend it by adding a filter. Up until now, we’ve only written filters in the
resource file where we just write a filter like this: filter

priority:

[greater_than: 3] or filter expr(priority > 3). But, as this is not a
resource and a manual relationship module, we have to use the Ash.Query module
to filter the records, which we have used in the above code snippet.
The return value of this load function should be a two-element tuple in the format
{:ok,

grouped_records}, where grouped_records are the related records

grouped by foreign key value matching the parent record. In this case, task records
have the foreign key attribute named project_id, and we return the results
grouped by this key.

141

9.9. How to Add Filters to Relationship?
Dev Story
Chaaru wants to define a relationship that contains an additional
filter. For example, in the Project resource, she already has a
has_many :tasks relationship defined, but she needs a new one to
relate to the Task resource again, but only for completed tasks.
We can create relationships conditionally by adding filters to them. Let’s see how
we can define a has_many relationship called :completed_tasks with a filter that
only retrieves tasks that are completed:

lib/tuesday/workspace/project.ex
has_many :completed_tasks, Tuesday.Assignments.Task do
filter [is_complete: true]
end

We simply call the filter macro within the do-end block of the relationship
definition to add a filter. We can add as many filters as we require. As seen in the
Ash Query chapter, it is also possible to use the expr to write complex filters.
Filters can be added to the following types of relationships:
1. has_many
2. has_one
3. many_to_many

9.10. How Do We Use Filters on Relationships in Ash Actions?
Dev Story
Tuesday wants to list all User records from organizations on a free
plan in the :owner role so that they can email them for possible
upgrades to a paid account. The User record contains the email
attribute, but the role information of the user is present in the

142

OrganizationMember, and the plan information is present in the
Organization. Chaaru knows how to do this in SQL and also in
Ecto using joins, but she sees no reference to joins in Ash
documentation, and she is wondering how to do this!
It is probably the easiest in Ash to use joins in filter expressions. Let’s say we want
to get all the users with the OWNER role who are part of free organizations. Below
is how we can do it using SQL:
SELECT users.email
FROM users
INNER JOIN organization_members ON users.id =
organization_members.user_id
INNER JOIN organizations ON organization_members.organization_id =
organizations.id
WHERE organizations.plan = 'free'
AND organization_members.role = 'owner';

In order to do the same in Ash, we can do it without worrying about joins and treat
them like a regular filter on attributes. So to filter on the relationship’s attribute, we
just use the dot syntax to refer to the attribute.

lib/tuesday/auth/user.ex
read :free_plan_owners do
filter expr(organization_member.role == "owner")
filter expr(organization_member.organization.plan_type == "free")
end

As shown above, organization_member.role joins the users table with the
organization_members
organization_members

table

and

table.

filters

on

Likewise,

the

role

column

the

filter

of

the
on

organization_member.organization.plan_type joins all three tables: users,
organization_members, and organizations and then adds a WHERE clause on the
plan_type field in the organizations table. Ash takes care of all the joins
required behind the scenes, relieving developers from manually joining tables for
querying related data.

143

9.11. How to Load Relationships in a Read Action in Ash?
So far, we’ve looked at how to define relationships. But when we try calling
Ash.read for any of the records, we don’t see these related records.
iex(1)> Ash.read_first!(Tuesday.Workspace.Organization, authorize?:
false)
#Tuesday.Workspace.Organization<
organization_members: #Ash.NotLoaded<:relationship, field:
:organization_members>,
projects: #Ash.NotLoaded<:relationship, field: :projects>,
id: "b160206f-a0b0-46fb-ab0c-fa8ac6e48a17",
name: "Organization 0",
plan_type: :enterprise,
can_standard_member_create_project: false,
inserted_at: ~U[2025-04-28 12:28:50.135682Z],
updated_at: ~U[2025-04-28 12:28:50.135682Z],
...
>

While we’re able to see other attributes, we’re not able to see the relationships as
they’re not loaded. To see the relationship data, we can simply call the read
functions by passing in load in the options:
iex(1)> Ash.read_first!(Tuesday.Workspace.Organization, load: [
:projects], authorize?: false)
#Tuesday.Workspace.Organization<
projects: [
#Tuesday.Projects.Project<
id: "300c2802-b15b-40e7-adf2-2cd7b156e71b",
name: "Project 0",
...
>,
#Tuesday.Projects.Project...

FYI, we can load multiple relationships with the following format:
[:relationship1, :relationship2]. In order to load nested relationships, we
could do so in the following format: [relationship1:

144

[:nested_relationship1, :nested_relationship2]].
iex> Ash.read_first!(Tuesday.Workspace.Organization, load: [projects:
:project_members], authorize?: false)
#Tuesday.Workspace.Organization<
id: "workspace-id"
projects: [
#Tuesday.Projects.Project<
id: "project-id"
project_members: [
#Tuesday.Projects.ProjectMember<
id: "project-member-id"
....

While passing in the load option to Ash.read_first! works, our relationships are
not loaded by default. In order to do that, in our read action, we can write the same
load arguments in prepare build() as shown below:
read :read do
...
prepare build(load: [organization_members: [:user]])
end

Ash provides many built-in preparations that we can use. In order to load
relationships, we use the build() built-in preparation, which is exactly what we’ve
used. build() converts the keyword list into an Ash Query using the
Ash.Query.build function that we have seen earlier in the Ash Query chapter. We
can also write a custom preparation when the built-in preparations do not suffice.
But, in most cases, the built-in preparations would be sufficient.
Now, we don’t need to pass the load option to Ash.read_first!:
iex(1)> Ash.read_first!(Tuesday.Workspace.Organization, authorize?:
false)
#Tuesday.Workspace.Organization<
id: "workspace-id"
projects: [
#Tuesday.Projects.Project<
id: "project-id"

145

project_members: [
#Tuesday.Projects.ProjectMember<
id: "project-member-id"
....

9.12. Managing Related Data
In Ash, it’s possible to create, modify, and delete related data of a resource from the
parent record. To do this, we can make use of the built-in manage_relationship
macro, which has an extensive list of options to configure as seen in the official
docs.
We will make use of two sets of relationships in Tuesday to understand this
concept:
1. Project & ProjectMembership
2. Organization, OrganizationMember & User
Here is how Project is linked with ProjectMember:
defmodule Tuesday.Projects.Project do
use Ash.Resource,
...
relationships do
has_many :project_members, Tuesday.Projects.ProjectMember do
description "OrganizationMembers assigned to this project."
end
end
end

Here is how ProjectMember is linked with Project and OrganizationMember:
defmodule Tuesday.Projects.ProjectMember do
use Ash.Resource,
...
relationships do
belongs_to :organization_member,

146

Tuesday.Workspace.OrganizationMember, allow_nil?: false
belongs_to :project, Tuesday.Projects.Project, allow_nil?: false
end
end

Here is how OrganizationMember is linked with User and Organization:
defmodule Tuesday.Workspace.OrganizationMember do
use Ash.Resource
...
relationships do
belongs_to :user, Tuesday.Auth.User do
allow_nil? false
end
belongs_to :organization, Tuesday.Workspace.Organization do
allow_nil? false
end
end
end

Here is how User is defined with an identity and no other relationship:
defmodule Tuesday.Auth.User do
use Ash.Resource,
...
attributes do
uuid_primary_key :id
attribute :email, :ci_string, allow_nil?: true
end
identities do
identity :unique_email, [:email]
end
end

For the rest of the chapter, we are going to cover manage_relationship. It has a

147

lot of options to configure, and it works with all types of relationships. At times, this
single macro can be one reason to feel Ash is so hard. However, in reality, the crux
of this macro is basically asking the following questions and finding a way to
manage the data in these scenarios:
Given a relationship between two resources, Project and ProjectMember, how do
we handle the user input that contains the information for both these resources in
different action types: :create, :update, :delete?
Assume that we got a project record p1 with two project_members: m1 and m2. If
the user provides three records, two of which match with m1 and m2, what should
Ash do with the third? Should it create a new record, ignore it, or throw an error?
What if the user provides input for two records for p1, and none of them match
with the existing records? What should Ash do with the new ones that are not
matching? Should it create, ignore, or throw an error, and more importantly, what
should it do with the existing two records that are not given by the user? Should it
delete the existing two records, unrelate them, or ignore them?
The above list of questions is not exhaustive. There are so many corner cases with a
relationship and input like this, and the manage_relationship macro thoughtfully
captures all these edge cases, making it feel like a difficult one to crack. In reality,
the framework developers have already thought about all these cases for us, and
what is left for us is to make use of the options available to us.
We have a lot to cover on what we can do with manage_relationship. Let’s go
through it one by one:

9.13. How to Create Related Data from the Parent Resource?
In this section, we look at how to create related data from the parent resource that
has one of the four relationships defined: belongs_to, has_one, has_many, or
many_to_many. The Project resource in Tuesday defines a has_many relationship
with ProjectMember. Let’s see how we can make use of this relationship to create
new ProjectMember records through an update action to a project record.
Let’s understand the public interface we want to use to add a new member.
ProjectMember

148

has

the

following

fields:

project_role,

organization_member_id, project_id: project.id
In Tuesday, we have the add_members action defined on the Project resource to
add new ProjectMember records, as shown below:

lib/tuesday/projects/project.ex
update :add_members do
description "Add an OrganizationMember to Project"
require_atomic? false
argument :project_members, {:array, :map}, allow_nil?: false
change manage_relationship(:project_members, :project_members,
on_no_match: :create)
end

If you notice, we have added require_atomic? false in the
:add_members action. This is because whenever we manage
related records through a parent record, these updates cannot be
done atomically at the database level and require preprocessing in
the application layer. Without this, Ash would complain that the
action cannot be performed atomically, and it’s perfectly okay to
turn off atomic updates for actions where we can’t.
As we can see in the above code, we are not accepting any input other than the
argument project_members, which takes a list of maps. This ensures that we use
this action strictly for adding members and not for updating any other fields.
For the manage_relationship macro, the first argument is the name of the
argument from which we get the input—in our case, project_members. The
second argument is the name of the relationship we want to affect—again,
project_members. The third argument is an options keyword list, which we will
explore more in this topic.
If the argument name and relationship name are the same, then instead of calling
the manage_relationship macro with three arguments, we can simply call it

149

using two arguments as shown below:
change manage_relationship(:project_members, on_no_match: :create)

We have provided on_no_match: :create as our options keyword list. This
means that if there is no match between the input and the existing project member
data, new project members will be created. By default, the criteria for checking a
match are based on the primary ID.
Let’s create some data for testing this out using Ash.Generator, which we cover
later in the book. Without going into the details, we are creating an
organization_member and a project record. Once we have both of these records,
we then update the project record to add the organization_member as the
project_member.
iex> import Tuesday.Generator
iex> org_member = Ash.Generator.generate(organization_member())
iex> project = Ash.Generator.generate(project())
iex> member_params = %{project_role: :owner, organization_member_id:
org_member.id, project_id: project.id}
iex> project_params = %{project_members: [member_params]}
iex> Projects.add_members(project, project_params, authorize?: false)
[debug] # Cleaned up query
INSERT INTO project_members (id, organization_id, project_id,
organization_member_id, project_role, inserted_at, updated_at) ...
{:ok,
#Tuesday.Projects.Project<
project_members: [
#Tuesday.Projects.ProjectMember<
id: "8b556d71-ea10-4316-a16a-bc28de8e5ed5",
project_role: :owner,
...
>
],

As we can see, there is an INSERT SQL for creating the new project member, and
the returned project record has the new project_member loaded in it.

150

The reason this works is that we are not providing an ID in our member params, so
it will always create new project members when using this action, as there is no
match.
It can be a bit annoying and unnecessary to provide project_id in the params,
especially since this is done using an update action on the Project resource. We
can write a custom change that automatically adds the project ID to the member
params behind the scenes, like how we have done in the Project resource replicated
below:

lib/tuesday/projects/project.ex
change fn changeset, ctx ->
project_id = Ash.Changeset.get_data(changeset, :id)
project_members = Ash.Changeset.get_argument(changeset,
:project_members)
updated_members = Enum.map(project_members, &Map.put(&1, :project_id,
project_id))
Ash.Changeset.set_argument(changeset, :project_members,
updated_members)
end

9.14. How to Update Related Data?
Let’s now move on to updating project members using the update action
:update_members in the Project resource.

lib/tuesday/projects/project.ex
update :update_member do
description "Update the member details at project level"
require_atomic? false
argument :project_member, :map, allow_nil?: false
change manage_relationship(:project_member, :project_members,
on_match: :update,
on_no_match: :error
)

151

end

The above code is quite similar to the previous code that we saw for adding project
members. We’ve now defined an argument called project_member, which takes in
a map as opposed to the previous version where the argument takes in a list of
maps. The reason is that we only want to update one member through the action.
Looking at the manage_relationship function, we can notice that we are using
the argument :project_member for the relationship :project_members.
In the third argument for setting options to manage_relationship, we’ve used the
keyword list: on_match:

:update,

on_no_match:

:error. This means,

whenever there is a match on the :id value given in the input with the existing
members, the project member will be updated with the given params. Whenever
there isn’t a match, i.e., there is no existing project member in the relationship, it’ll
raise an error as we can’t update a project member that doesn’t exist in the
relationship.
Below, we again make use of Tuesday.Generator for creating a project_member
record with the :standard role and then update this record to the :admin role
using the update_member action shown above. We make use of Code Interface
functions

defined

for

this

action

for

ease

of

use,

but

directly

using

Ash.Changeset.for_update and then manually calling Ash.update will also
result in the same behaviour.
iex> import Tuesday.Generator
iex> %{project_member: project_member, project: project} =
create_project_member(project_role: :standard)
iex> params = %{
project_member: %{
id: project_member.id,
project_role: :admin
}
}
iex> Projects.update_member(project, params, authorize?: false)
[debug] # Cleaned up SQL
UPDATE project_members SET project_role = 'admin'.. WHERE id =

152

'415e1b...3247'
{:ok,
#Tuesday.Projects.Project<
project_members: [
#Tuesday.Projects.ProjectMember<
id: "415e1b20-f9bf-4de0-a873-84ae3c0b3247",
project_role: :admin,
...
>
],

It is very important to pass in the ID in the project member in the params because
the implementation of on_match relies on it. Please note that it is also possible to
update multiple project members in this action if our argument instead takes a list
of maps. But we chose not to do that in Tuesday as it makes much more sense to
update a single member instead of multiple members.

9.15. How to Delete Related Data?
Let’s now look at how we can remove a project member using the update action
delete_member.

lib/tuesday/projects/project.ex
update :remove_member do
description "Remove the member from the project"
require_atomic? false
argument :project_member, :map, allow_nil?: false
change manage_relationship(:project_member, :project_members,
on_match: {:destroy, :destroy},
on_no_match: :error
)
end

As we can see from the above code, it is very similar to the previous code that we
saw for updating a project member. So far, these are the options to affect the

153

relationship data, and they are:
1. on_no_match: :create - for creating members
2. on_match: :update - for updating project member
We’re actually passing in the action type as the value to the on_match and
on_no_match keys. The function works by using the primary action of the action
type to apply the params to the ProjectMember resource. In our case, our primary
actions are defined using the defaults macro inside our resource. If we want to
specify the action we want to be using, we can pass in a tuple to the on_match and
on_no_match keys: {:action_type, :action_name}
Ash doesn’t allow us to pass in the action type directly with the case of on_match.
We have to specify our action type and action explicitly. That is exactly what we’ve
done by having the following option: on_match: {:destroy, :destroy}. So,
whenever there’s a match, the project member gets deleted. Due to the option
on_no_match: :error, whenever there isn’t a match, it’ll raise an error as we
can’t delete a project member that doesn’t exist in the relationship.
Below, we again make use of Tuesday.Generator for creating a project_member
record and then we delete this record using the remove_member action shown
above.
iex> import Tuesday.Generator
iex> %{project_member: project_member, project: project} =
create_project_member(project_role: :standard)
iex> params = %{
project_member: %{
id: project_member.id,
}
}
iex> Projects.remove_member(project, params, authorize?: false)
[debug] # Cleaned up SQL
DELETE FROM project_members WHERE id = '3fcc7540-fa1b-4941-944f49abcb836082'
{:ok,

154

#Tuesday.Projects.Project<
project_members: [],
id: "d9d557d8-2347-4891-a4d3-24e509a85961",
...
>}

As seen above, calling the remove_member function with valid params for an
existing member deletes it from the database.

9.16. How to Affect Related Data Based on Identities?
In Tuesday, we have Organization defining a has_many relationship to
OrganizationMember. The OrganizationMember, in turn, belongs to the User
resource, which has a unique email identity defined in it. This means for the entire
Tuesday app, there cannot be two User records with the same email ID.
Now with this constraint, think of the scenario where we want to invite a User to an
Organization. This would require creating an OrganizationMember record linking
both the Organization and the User record. What we are trying to achieve here is to
invite a User record to be come an OrganizationMember by their email address. If
there is a User with the given email address, we want that existing user to be
created as the OrganizationMember but if no User is present with the given email
address, then we want to create a new User record and then link this User record to
the newly created OrganizationMember record.
It is apparent that we would use the manage_relationship function to implement
the feature and also that we would be using on_no_match: :create because we
want to create a new User record if there is no match in the existing records.
But there is a small issue. The default matching is done using the primary ID and
not by any other attribute. If we want the matching to be based on an attribute,
then it has to be defined as an identity. The email field is defined as an identity,
and hence, we could add the following option for the manage_relationship
macro: use_identities: [:identity1, :identity2].
In our case, the identity that we want to use for matching is :unique_email, and
the

complete

option

for

manage_relationship

looks

like

this

on

the

OrganizationMember resource:

155

change manage_relationship(:email, :user,
on_match: :error,
on_lookup: :relate,
on_no_match: :create,
value_is_key: :email,
use_identities: [:unique_email]
)

Both on_match and on_no_match options concern themselves with the data that is
already present in the relationship. They don’t care if there is a user who exists
outside of the relationship. But, in our case, we should associate the user if the user
exists outside the relationship. This can be achieved by adding the following option:
on_lookup: :relate. In a belongs_to relationship like OrganizationMember
belongs_to User, this would update the OrganizationMember record using the
primary update action with the user ID found existing outside the relationship.
We don’t need to pass in a map argument in manage_relationship as an
argument at all times. There may be cases where we are only able to give a params
map with only one key and value. We can pass an argument whose value is the
same as the attribute value. Our User resource is a very good example of this as it
only has one attribute, i.e., email. In our case, email is of string type, so we need to
define a string argument, then we can pass in that string argument to
manage_relationship. Additionally, we need to add the following option
value_is_key: :email, and Ash would enclose the string value into a map like
this %{email: "some email given as argument"}.
Overall, this is how the action looks now:

lib/tuesday/workspace/organization_member.ex
create :invite_org_member do
description """
Register `User` identified by the `email` as the
`OrganizationMember`
If a `User` exists for the given email, then register them as
`OrganizationMember`.
If no `User` exists for the email id, then create a new `User` with
the email given and then

156

proceed to registering the newly created User as the
`OrganizationMember`.
"""
argument :email, :string, allow_nil?: false
change manage_relationship(:email, :user,
on_match: :error,
on_lookup: :relate,
on_no_match: :create,
value_is_key: :email
)
...
end

Below is how we’d be creating or relating a user using the code interface based on
our action:
iex> org = Ash.Generator.generate(organization())
iex> Workspace.invite_org_member(%{username: "chaaru", email:
"chaaru@example.com", organization_id: org.id}, authorize?: false)
{:ok, %OrganizationMember{username: "chaaru", user: %User{email:
"chaaru@", ...}, ...}

We have covered a lot of complex relationships using manage_relationship now.
It can be overwhelming to start with, but once we get a hang of how it works, then
we will see ourselves using it everywhere because it’s very flexible to meet all kinds
of requirements.
When using the action :remove_member in the previous section,
our argument was a map despite the fact that it will only work
based on the key id. Can we figure out how we can use
value_is_key so that we can just pass id as an argument instead
of a map argument comprising id?
Throughout this topic, we have only been looking at some options provided by the
manage_relationship function, and it boasts many options that might be very

157

useful in various cases. We invite ourselves to check out the documentation and
learn more about it here.

9.17. Summary
The chapter explored how to define and manage relationships between resources,
using the Tuesday application’s Task, Project, Organization, and related
resources as examples. Below are the key concepts covered.

9.17.1. Key Concepts
• Four Standard Relationships: Ash supports four relationship types:
belongs_to, has_many, had_one, many_to_many.
• Relationships Without Foreign Keys: Defined using no_attributes? true
and filter.
• Manual Relationships: Defined with manual {Module, opts}, where a
custom module implements the Ash.Relationship behaviour’s load/3
function to query and return group related records.
• Filtering and Loading: Relationships can be filtered using filter with expr.
Relationships are fetched using the load option and supports nested
relationships (e.g., load: [projects: :project_members]).
• Managing Related Data: The manage_relationship macro in actions handles
creating, updating, or deleting related records. Options include:
◦ on_no_match: :create/error: create new records or error if no match.
◦ on_match: :update/:destroy: update or delete matched records, e.g.,
on_match: {:destroy, :destroy}.
◦ on_lookup: :relate: link existing records outside the relationship.
◦ use_identities: [:identity_name]: match based on identities like
unique_email.
◦ value_is_key: :field: map single-value inputs to attributes, e.g., email
to %{email: value}.

158

Chapter 10. Aggregates

10.1. What is a Resource Aggregate?
Resource aggregates provide us with a way to summarize data from a resource’s
relationships. By defining aggregates, we can, for example, obtain the task count for
a project or calculate the average story point of all tasks in a project. We define all
our aggregates within the aggregates block in our resource.
There are a total of 8 different types of aggregates that we can define within a
resource and they are:
1. count
2. exists
3. first
4. sum
5. list
6. max
7. min
8. avg
It’ll become much clearer when you see how we define them. All of our aggregates
are defined under the aggregates block in our resource:

lib/tuesday/workspace/organization.ex
defmodule Tuesday.Workspace.Organization do
...
aggregates do
...
end
end

159

We’ll go through each one of the 8 built-in aggregates in this chapter.

10.2. How do I define a count aggregate?
Dev Story
Chaaru wants a feature in Tuesday to show the organization
admins, the number of members in their organization. This
information is important for the organization admins to know
regularly because Tuesday bills the organization by the number of
seats used as per their billing plan. For example, organization
dashboard could show “Total Team Members: 42” enabling the
admins to manage the team billing & usage effectively and plan
upgrades if the limit approaches.

Chaaru knows that this count relies on the relationship between the Organization
and its many OrganizationMember resources in Tuesday.Workspace. In plain
SQL, she would write a simple SQL like:
SELECT COUNT(*) AS total_member_count FROM organization_members where
organization_id = 'ID-OF-THE-ORG';

160

He just needs to know how to achieve the same in Ash aggregates.
Aggregates like these are defined in the parent entity that defines the has_many
relationship.
The count macro is used to calculate the count of number of records in a
relationship as shown below:

lib/tuesday/workspace/organization.ex
defmodule Tuesday.Workspace.Organization do
...
aggregates do
count :total_member_count, :organization_members
end
end

The first argument to count macro is the name for our aggregate. It can be any
name as long as it’s unique within the resource. This name corresponds to our AS
alias in SQL. The second argument to the count macro contains the relationship
name as defined in our resource for which we want to find the count aggregate. In
our case, the relationship is named as :organization_members in our
Organization resource

lib/tuesday/workspace/organization.ex
defmodule Tuesday.Workspace.Organization do
...
relationships do
has_many :organization_members, Tuesday.Workspace.OrganizationMember
do
source_attribute :id
destination_attribute :organization_id
end
end
end

If later Chaaru changes her mind and wants to show the count of only active

161

members for the billing purpose of Tuesday, we can add filters to the count
aggregate as well. This requires only small change in our aggregate code.

lib/tuesday/accounts/organization.ex
defmodule Tuesday.Workspace.Organization do
...
aggregates do
...
count :active_members, :members do
description "Count of active members."
filter expr(status == "active")
end
end
end

As we can see in the code snippet above, the filter can be added to the count
aggregate by adding a do-end block to the count macro. It is one of the options of
the count function. Filter can be applied to all the other aggregates as well.
This is equivalent to writing an additional AND filter in the SQL in addition to the
filter on organization_id which we saw earlier.
SELECT COUNT(*) AS total_member_count FROM organization_members where
organization_id = 'ID-OF-THE-ORG' AND status = 'active';

10.3. How do I define an exists aggregate?
Dev Story
Chaaru wants to visually distinguish tasks inside a project that have
sub-tasks from the ones that don’t, like a small indicator for each
task saying “Has Sub-Tasks: Yes” or “No”.

162

Chaaru knows that this depends on the Task resource in Tuesday.Projects,
which has a self-referential relationship allowing a task to have many sub_tasks.
The system must check this relationship and return a boolean—true if sub-tasks
exists, false if not. In plain SQL Chaaru knows how to do this:
SELECT
id,
title,
EXISTS (
SELECT 1
FROM tasks AS st
WHERE t.id = st.parent_task_id
) as has_sub_tasks
FROM
tasks AS t;

We can use exists macro inside our aggregates block to check if a record exists
in a relationship or not. It returns a boolean.

lib/tuesday/assignments/task.ex
relationships do
has_many :sub_tasks, Tuesday.Projects.Task do
source_attribute :id

163

destination_attribute :parent_task_id
end
...
end
aggregates do
...
exists :has_sub_tasks, :sub_tasks
end

The first argument the exists macro is the name we want to give to this aggregate
and the second one is the relationship that we want to check. Even though in this
example we used a self-referential relationship, this works the same way with nonself referential relationships as well.

10.4. How do I define a sum aggregate?
Dev Story
From her experience working in many large projects, Chaaru
knows that stakeholders often want to get a quick overview of
effort estimates across all tasks in a project. To support this, she
wants projects in Tuesday to display the total story points assigned
to a project by summing all the story_point values of all its tasks.
This is quite tricky but let’s break it down. Chaaru know how to do a sum aggregate
for a single project, which is:
SELECT
SUM(t.story_point) AS total_story_points
FROM
tasks AS t
WHERE
t.project_id = 'eba9310c-be99-4087-b78b-d1cc9a9f9ebe'

This applies to a display like the one shown below, where we are viewing a single
project.

164

But we want this total_story_points to be calcualted when we are viewing a list
of all projects as in the screenshot below:

This would mean Chaaru needs to do a LATERAL join in his SELECT query for
projects like this:
SELECT
p.id,
p.name,
s.total_story_points
FROM
projects AS p
LEFT JOIN LATERAL (

165

SELECT
SUM(t.story_point) AS total_story_points
FROM
tasks AS t
WHERE
t.project_id = p.id
) AS s ON TRUE;

While it may look daunting to arrive at this SQL for beginners, it’s easy to do it in
Ash with a single line of configuration as shown below:

lib/tuesday/workspace/project.ex
aggregates do
...
sum :total_story_points, :tasks, :story_point
end

We use the sum macro to define a sum aggregate which takes in three arguments.
1. The

first

argument

is

the

name

we

are

giving

to

this

aggregate

:total_story_point which is equivalent to the SQL alias statement.
2. The second argument is the relationship that we want to use for the sum, which
in our case is tasks. This is equivalent to the lateral subquery join table.
3. Finally the third argument is the field in the relationship whose value we want
to sum up. The attribute that we want to sum up is :story_point.
This sets the foundation for similar aggregate insights — like filtering the
total_story_points only for pendings tasks. Filters inside an aggregate work
same everywhere.
You could take it as a challenge to retrieve the sum of story points from tasks that
are not completed. You can refer to the previous topic where we’ve added a filter
count only active members.

166

10.5. How do I define a max and min aggregate?
Dev Story
Chaaru wants Tuesday to display the highest story point value
among all tasks in a project, so project leads can quickly identify
large tasks that may need to be split or discussed in retrospectives.
For example, the project dashboard could show "Max Task Size: 8
Story Points," enabling the project lead to make informed decisions
without manually checking each task.

Let’s start with SQL to understand the concept as usual. This is what Chaaru is using
without Ash.
SELECT p.id, p.name, s.max_story_point
FROM projects AS p
LEFT JOIN LATERAL (
SELECT MAX(t.story_point) AS max_story_point
FROM tasks AS t
WHERE t.project_id = p.id
) AS s ON TRUE;

167

The max aggregate in SQL is straightforward, like the sum. We simply specify a field
to calculate its maximum value. We can replicate this in our Ash project using the
max aggregate:

lib/tuesday/workspace/project.ex
aggregates do
...
max :max_story_point, :tasks, :story_point
end

We use the max macro to define a max aggregate, which takes three arguments:
• The name of the aggregate, :max_story_point, equivalent to the SQL alias.
• The relationship to use for the aggregate, in our case, tasks, similar to the
lateral subquery join table.
• The field in the relationship for which to find the maximum value, here
:story_point.
The min aggregate works similarly to the max aggregate but retrieves the minimum
value of an attribute in the relationship. To get the minimum story points for tasks
in a project, we can define it as follows:

lib/tuesday/workspace/project.ex
aggregates do
...
min :min_story_point, :tasks, :story_point
end

10.6. How do I define an avg aggregate?
Dev Story
Chaaru wants Tuesday to show the average story point value for
tasks in each project, so team leads can assess estimation accuracy
and maintain balanced workloads. For example, the project

168

dashboard could display “Average Task Size: 5 Story Points,”
helping team leads identify projects with unusually high or low
effort and refine estimation practices.
The avg aggregate is used to get the average value of an attribute in the
relationship. If we want to get the average number of story points of tasks in a
project, below is how we do it:

lib/tuesday/workspace/project.ex
aggregates do
...
avg :avg_story_point, :tasks, :story_point
end

10.7. How do I define a list aggregate?
Dev Story
Chaaru wants Tuesday to include a list of active project names in a
monthly email summary, so organization admins can stay informed
about the number of projects in progress. For example, the email
could include “Active Projects: Project A, Project B, Project C,”
providing a clear overview of ongoing work.
The list aggregate is used to get the list of all values of an attribute in the
relationship. If we want to get the list of all project names of an organization, we
can do so like below:

lib/tuesday/workspace/organization.ex
aggregates do
...
list :project_names, :projects, :name
end

10.8. How do I define a first aggregate?

169

Dev Story
Chaaru wants Tuesday to display the name of the first task created
in each project, so project managers can quickly identify how
projects began and assess their kickoff patterns. For example, the
project dashboard could show “First Task: Initial Setup,” enabling
her to review project initiation without manually checking task
lists.
This example is somewhat complex because, ideally, for a feature like this, we
would want the result to be a linkable reference to the actual task entity. Instead of
just displaying the task’s title, we would prefer a linked title that directs the user to
the relevant task’s details. To achieve this, we should define a has_one relationship
on the Project resource with additional filters to identify the first task created.
Refer to the relationships section for guidance on setting up such a relationship.
For the purpose of explaining the first aggregate, let’s go with the user story that
Chaaru just wants the first task name to be displayed for each project.
The first aggregate is used to get the attribute value of the first record in the
relationship. To get the name of the first task in a project, we can do so like below:

lib/tuesday/projects/project.ex
first :task_name, :tasks, :title do
sort [:inserted_at, :asc]
end

We’ve used the sort option to sort the tasks by inserted_at in ascending order.
That way, we get name of the first ever task that is inserted.

Do we have similar last aggregate?
No. We can also use the same first aggregate but reverse the sort
order to :desc to get the last record’s attribute value

170

10.9. How do I load aggregates in queries in Ash?
Dev Story
Chaaru has implemented the total_story_points in the Project
resource

but

she

is

using

Ash.load!(project,

[:total_story_points]) everytime she wants to display the total
story points for a project. She is aware of N+1 queries and its impact
on performance when she has to do these loads inside a loop but
she is unsure how to load the aggregates automatically when listing
the projects.

iex> Ash.load!(project, [:total_story_points])

So far Chaaru has been doing this to load the aggregate fields but we could also
instruct our actions for listing projects to load the aggregate fields automatically.
Aggregate and Calculation fields are not loaded automatically to avoid unnecessary
database queries but when they are needed for every result in an action, we can
load them like we load relationships using prepare function in the read action:

lib/tuesday/workspace/project.ex
read :read do
...
prepare build(load: [:total_story_points])
end

Having done this, we can now see the total story points in a project by default when
performing the read action. If we need to load the total_story_points for
multiple projects, this approach avoids N+1 queries. For example, if we load all
projects with their total_story_points, as shown below, Ash executes this in a
single database query:
iex> Ash.read(Tuesday.Projects.Project, authorize?: false, load:
:total_story_points)
[debug] # Cleaned up SQL
SELECT p.id, p.name, ... FROM projects AS p LEFT OUTER JOIN LATERAL

171

(SELECT project_id, SUM(story_point)::bigint AS total_story_points FROM
tasks WHERE p.id = project_id GROUP BY project_id) AS s ON TRUE;
...

10.10. How do I filter based on aggregates in Ash?
Dev Story
Chaaru wants Tuesday to list projects with total story points
exceeding a certain thresold, so that organization admin can
prioritize staffing for high-effort projects. For example, the
organization dashboard could show “High-Effort Projects: Project X
(75 points), Project Y (60 points),” enabling admins to focus on
critical projects efficiently.
The beauty of Ash aggregates is that once we define them, we can use these
aggregates as any other attribute in our filters in any actions. We have already
defined total_story_points as an aggregate in Project resource. Now we just
need to define a read action in Project that can take in an arbitrary
sp_threshold value to get the input from the user. The fully complete read action
is below with all the load and filter configuration to suit our needs.

lib/tuesday/workspace/project.ex
read :high_story_point_projects do
argument :sp_threshold, :integer
prepare build(load: [:total_story_points])
filter expr(total_story_points > arg(:sp_threshold))
end

In the above code example, our read action high_story_point_projects first
loads the :total_story_points aggregate using the prepare function. This
makes the aggregate available for use in our filters. We then use the aggregate
name in the filter expression, just as we would use an attribute name, to filter
projects with total story points exceeding the value of the input argument
sp_threshold.

172

10.11. Summary
The chapter explored Ash Resource Aggregates, which summarize data from
related resources, using the Tuesday application’s Organization, Project, and
Task resources as examples. Below are the key concepts covered.

10.11.1. Key Concepts
• Aggregate Overview: Aggregates, defined in an aggregates block, compute
summary data from a resource’s relationships (e.g., task counts or average
story points). Ash supports eight aggregate types: count, exists, first, sum,
list, max, min, and avg.
• Count Aggregate: count :name, :relationship counts related records,
filterable with expr (e.g., active members).
• Exists Aggregate: exists :name, :relationship returns a boolean for
related record existence (e.g., “Has Sub-Tasks”).
• Sum Aggregate: sum :name, :relationship, :field sums an attribute for
metrics like project effort.
• Max/Min Aggregates: max/min

:name,

:relationship,

:field finds

extreme attribute values (e.g., largest task).
• Avg Aggregate: avg :name, :relationship, :field computes average
attribute values (e.g., task size).
• List Aggregate: list :name, :relationship, :field lists attribute values
(e.g., active project names).
• First Aggregate: first :name, :relationship, :field gets an attribute
from the first record, sorted by sort; use has_one for full records.
• Loading Aggregates: Load aggregates with Ash.load!/2 or prepare
build(load: [:total_story_points]) to avoid N+1 queries.

173

Chapter 11. Calculations

11.1. What is a Resource Calculation?
A resource calculation is a calculated value based on attribute, relationship,
aggregate data or some plain expression. All our calculations are defined under the
calculations block in our resource.
defmodule User do
...
calculations do
# All calculation definitions go here
calculate :price_with_currency, :string, expr(first_name <> " " <>
last_name)
end
end

We define a calculation using the calculate macro where the first argument is the
name of the calculation, second argument is the data type that is returned by the
expression and the final argument is the expression that we want to calculate.
Above is a very simple example of defining a calculation which returns the
full_name by concatenating first_name and last_name.

Return Type Specification
If we compare the calculation macro to the aggregate macro,
we can notice that calculations required the return data type to be
explicitly mentioned while in aggregates, we didn’t. This is because
the data type can be automatically inferred in the aggregate
functions. For example, :integer for the count aggregate but we
cannot infer the type automatically in calculations because we can
use any expression or even custom functions and resulting type is
not known automatically!
If we have complex calculations that need more than just a single expression. We

174

can define a module calculation like below:
defmodule SomeModuleCalculation do
use Ash.Resource.Calculation # This makes it a module calculation
@impl true
def init(opts) do
{:ok, opts}
end
@impl true
def calculate(records, opts, _context) do
# This should return whatever that we want to display
end
end

Then, we can use the module calculation like below:
calculation :calculation_name, :type, {SomeModuleCalculation, []}

In this chapter we will look at a couple of calculations from Tuesday project to give
you a variety of examples using calculations. As usual, Chaaru, the developer at
Tuesday, sharing us his requirements.

11.2. How do I define calculations using expr?
Dev Story
In Tuesday, the Task resource has a due_date attribute that
captures the due date of individual task records. Chaaru is
developing a feature to display an overdue status for all tasks.
While she could implement a conditional check in the templates to
determine if the due_date is earlier than today and the task is
incomplete, is there a more efficient way to achieve this using Ash?

175

In the previous chapter, we saw that aggregates are particularly useful in getting
summary of data from relationships. But, with calculations, we can perform
operations on our attributes of the resource and it allows us to derive new pieces of
information.

lib/tuesday/assignments/task.ex
calculations do
calculate :is_overdue, :boolean, expr(due_date < today() and not
is_complete)
end

In the above code snippet, we’ve defined a calculation called :is_overdue. We’ve
used an expression which checks if the due_date is less than today’s date. today()
is a function that can be used inside expressions to get today’s date and we also
check if task is still incomplete by checking the is_complete value.
Defining the calculation doesn’t automatically make it available to use when we
query the records.
Similar to loading relationships and aggregates, we have to load calcaulations using
the load option in the Ash.read() function explicitly or using the prepare
function in the read action.
We can load the calculation using the Ash.read() function as shown below

176

iex(1)> Ash.read(Tuesday.Projects.Task, load: [:is_overdue], authorize?:
false)
{:ok,
[
#Tuesday.Projects.Task<
progress_percentage: #Ash.NotLoaded<:calculation, field:
:progress_percentage>,
is_overdue: false,
id: "14758976-bc0e-4aff-a297-52eb7e67f0c4",
title: "Task 0",
...

or using the prepare function in the read action which would then always load the
calculation everytime the action is called.
The following code is not added in Tuesday code but shown here as an example.
You can add repare build(load: [:is_overdue]) to any read action as
needed.

lib/tuesday/assignments/task.ex
read :read do
...
prepare build(load: [:is_overdue])
end

11.3. How do I use calculations in filters in Ash?
Dev Story
The Product Owner at Tuesday came up with a new requirement
for Tuesday. In addition to displaying the task’s is_overdue status,
she wants to create a new section that displays all the overdue
tasks. Chaaru think she could write a dedicated action for this using
the same conditions she has used in the calculations. Is there a
better way?

177

Chaaru has come up with this action to get all overdue tasks:

lib/tuesday/assignments/task.ex
read :overdue_tasks do
filter expr(due_date < today() and not is_complete )
end

While this is correct and does the job, we can do better. Everything that we write
using Ash macro is stored as data and we can always reuse this data. This helps us
avoid duplicating the logic in multiple places and reduces the maintenance burden
of updating them everywhere when the business changes the logic behind certain
operations.
Since we have already defined the conditions for marking a task as overdue in a
calculation, we can reuse it in filters, just as we use attributes, aggregates, and
relationships. The only requirement for using a calculation in a filter is that it must
be loaded first. Let’s explore an example where we use the :is_overdue
calculation to retrieve all overdue tasks:

lib/tuesday/assignments/task.ex
read :overdue_tasks do

178

prepare build(load: [:is_overdue])
filter [is_overdue: true]
end

11.4. How do I define calculation using fragments?
Dev Story
For each Project displayed in Tuesday, Chaaru is developing a
new feature to display the number of days left remaining before
reaching the end date for that project. We already know that we
have a end_date attribute in Project resource with date type.
Chaaru looked at the available expressions in Ash documentation
and none of it seems to be related to what she is trying to achieve.

Chaaru knows how to do this in SQL. It’s pretty straight forward for him but needs
to know how to translate this into Ash calculations.
In SQL, she would run this query to get days_until_deadline value:
SELECT id, name, EXTRACT(DAY FROM age(end_date, current_timestamp)) as
`days_until_deadline` FROM projects;

In situations like this when we don’t have an Ash equivalent of a query we would
like to run, we can use Ash fragment. In the above SQL query, we have three fields
selected from projects table: id, name and days_until_deadline as an
expression. When using fragment in our calculation, we can put the entire
expression we used in the SQL query as shown below:

179

lib/tuesday/assignments/project.ex
calculations do
...
calculate :days_until_deadline,
:integer,
expr(fragment("EXTRACT(DAY FROM age(end_date,
current_timestamp))")) do
description "Days remaining until the project end date."
end
end

In case, we want to pass in dynamic values from our application to the SQL
fragment, then we could replace those dynamic values using ? and pass these
dynamic values as additional arguments to fragment macro.
This is unnecessary for our use case, but below we show how to use fragments with
dynamic values. Note that we replace end_date within the string with ? and pass
end_date as the second argument to the fragment macro.

lib/tuesday/assignments/project.ex
calculations do
...
calculate :days_until_deadline,
:integer,
expr(fragment("EXTRACT(DAY FROM age(?, current_timestamp))",
end_date)) do
end
end

11.5. How to use Aggregates in Calculations?
Dev Story
Chaaru has already created a few aggregates for the Project
resource. She already has total_tasks_count aggregate which
gives the total number of task records for a given project and

180

completed_tasks_count aggregate which gives the total number
of task records whose is_complete value is true. Now Chaaru
wants to do a simple arithmetic calculation on these two aggregates
to calculate the percentage of task completion.

Refer to the previous chapter for understanding how Aggregates work and to the
Tuesday code base to see how these aggregates total_tasks_count and
completed_tasks_count are defined.
If we look at the SQL needed to do this task, it looks hugely scary:
SELECT
projects.id,
task_summary.task_count as total_tasks,
task_summary.completed_tasks as completed_tasks,
(
CASE
WHEN COALESCE(task_summary.task_count, 0) > 0 THEN
(
COALESCE(task_summary.completed_tasks, 0)::decimal
/
COALESCE(task_summary.task_count, 0)::decimal
) * 100.0
ELSE
0.0
END

181

)::float as completion_percent
FROM
projects
LEFT OUTER JOIN LATERAL (
SELECT
tasks.project_id AS project_id,
COALESCE(
COUNT(*) FILTER (WHERE true),
0
) AS task_count,
COALESCE(
COUNT(*) FILTER (WHERE tasks.is_done = true),
0
) AS completed_tasks
FROM
tasks
WHERE
projects.id = tasks.project_id
GROUP BY
tasks.project_id
) AS task_summary ON TRUE;

which would give us a response like
id

| total_tasks | com.._tasks | comp.._percent

------+-------------+-------------+--------------7..1 |

10 |

5 |

50

Fortunately, writing such a query is straightforward with Ash. We treat aggregates
like any other field on our resource and perform simple arithmetic calculations
using expr. Ash internally converts these aggregates into the appropriate joins.

lib/tuesday/assignments/project.ex
calculations do
...
calculate :completion_percentage, expr((completed_tasks_count /
total_tasks_count) * 100)
end

182

We just passed the aggregates to the Ash’s expr of calculate macro like
(completed_tasks_count / total_tasks_count) * 100 and everything else
is taken care.
Ash ensures we avoid division-by-zero errors in the above
expression by wrapping the resulting SQL expression in a WHEN
clause that checks if the task count is greater than zero before
proceeding with the division: COALESCE(subquery.task_count,
0) > 0.
The

above

code

example

assumes

that

we

have

defined

the

completed_tasks_count and total_tasks_count aggregates. If we don’t have a
use case for the aggregate other than for the purpose of this calculation, then we
can use inline aggregates and avoid unnecessary aggregate definitions which we
don’t use really.
To do exactly the same as above but without using dedicated aggregates, we change
the calculate definition for completion_percentage as shown below:

lib/tuesday/assignments/project.ex
calculations do
...
calculate :completion_percentage,
:float,
expr(count(tasks, query: [filter: [is_complete: true]]) /
count(tasks) * 100) do
description "Percentage of completed tasks."
end
end

This count function aggregates from the given relationship. Comparing our earlier
calculate defintion with aggregates and with this new one, we can see that we
have replaced
1. completed_tasks_count

with

count(tasks,

query:

[filter:

[is_status: true]])

183

2. total_tasks_count with count(tasks)
The important macro here is the count/2 macro which takes in the relationship to
count and an optional configuration.
The first time we call count aggregate macro, we’ve passed the relation tasks to
count with an query option to the count only the completed tasks. The query
option takes the expression accepted by Ash.Query.build which we saw in Ash
Query chapter.
The second time we call count, we don’t pass any query option and it gets the total
count of tasks.
Just like how we’ve used this count function in our expression, all
other aggregate functions as well can be used in the expression. The
options of those functions are the same as this function
Ash.Query.Aggregate.new() here. Behind the scenes, Ash uses
this function when we call count or any other aggregate function in
our expression.
Chaaru’s life is simpler with Ash’s calculation and so is your life too!

11.6. Summary
The chapter explored Ash Resource Calculations, which derive values from
attributes,

relationships,

aggregates,

or

expressions,

using

the

Tuesday

application’s Task and Project resources as examples. Below are the key concepts
covered.

11.6.1. Key Concepts
• Calculation Overview: Calculations, defined with calculate :name, :type,
expr(…), compute values from resource data, requiring explicit return types
due to expression variability.
• Expression-Based Calculations: expr calculations derive values for logic like
overdue tasks.

184

• Filtering with Calculations: Calculations, loaded via prepare build(load:
[:is_overdue]), filter like attributes (e.g., filter [is_overdue: true]) to
reuse logic without duplication.
• Fragment-Based Calculations: fragment embeds raw SQL for complex
operations.
• Calculations with Aggregates: Calculations combine aggregates or inline
aggregates for derived metrics.
• Module Calculations: Module calculations (e.g., calculate :name, :type,
{Module, opts}) use Ash.Resource.Calculation behaviour for complex
logic with init/1 and calculate/3.
• Loading Calculations: Calculations, not loaded by default, are included with
Ash.load!/2 or prepare build(load: [:is_overdue]) in reads.

185

Chapter 12. Notifier
An Ash notifier is an idiomatic way to react to changes in a resource, such as
creating, updating, or deleting records. For example, if we want to send an email
after registering a new user, the resource change is the insertion of a new user
record, and the reaction is sending the email. Notifiers handle these side effects
cleanly after an action completes. Common use cases include audit logging user
activities, broadcasting real-time updates, or triggering external jobs like email or
push notifications. If we need to manage side effects tied to resource changes, an
Ash notifier is the ideal solution.
A notifier is an Elixir module that implements the Ash.Notifier behaviour,
requiring only the notify/1 function to process a notification. Here is a simple
example:
defmodule ActivityLogger do
use Ash.Notifier
def notify(notification) do
IO.puts("Got notification: #{inspect(notification)} in
ActivityLogger")
:ok
end
end

The Ash.Notifier behaviour defines two callbacks:
@callback notify(Ash.Notifier.Notification.t()) :: :ok
@callback requires_original_data?(Ash.Resource.t(),
Ash.Resource.Actions.action()) :: boolean

Using use Ash.Notifier in our module automatically injects the following code
into

our

module,

providing

a

default

implementation

for

requires_original_data?/2. This default implementation can be overridden if
needed:

186

@behaviour Ash.Notifier
def requires_original_data?(_, _), do: false
defoverridable requires_original_data?: 2

This means we only need to implement notify/1 in our notifier, as shown in the
ActivityLogger example. The requires_original_data?/2 callback is optional
and used only when our notifier needs the resource’s state before a change (for
example, to compare old and new values).

12.1. How do notifiers differ from writing code in our action to
perform tasks after it runs?
In Ash, actions like create, update, and destroy run inside a database transaction.
We could write side effects (for example, sending emails or logging) in action hooks,
which are code snippets that execute before or after specific action events.
However, these lifecycle callbacks do not guarantee the action’s success or that data
is committed to the database. For example, an after_action callback runs before
the transaction commits, so if the transaction rolls back (for example, due to a
constraint violation), our side effect (such as sending an email) might act on
uncommitted data, leading to incorrect behavior. The after_transaction hook is
not ideal either—it triggers regardless of success or failure, requiring us to check
the outcome manually.
Ash notifiers solve this by running only after a successful transaction commit,
ensuring that side effects (for example, notifications or logging) reflect committed
data. They simplify the process by handling the success check for us, avoiding the
complexity of managing conditional logic in hooks. If we need side effects for failed
actions, we can use action hooks like after_action or after_transaction with
explicit checks.

12.2. Do Ash Notifiers guarantee our side effects at all times?
No, Ash notifiers are classified as "at most once," meaning the side effect (for
example, sending an email) might fail silently without retrying. This is acceptable
for non-critical tasks, like logging or analytics, but for critical side effects, such as

187

sending a welcome email to every new user, Ash notifiers could fail in certain cases
and might not be acceptable. For example, if the email service is temporarily down
when a user registers, the notifier is triggered but does not track whether the email
was sent successfully. Similarly, buggy code in our notifier could cause the side
effect to fail after the database transaction commits, leaving data saved but the
notification undelivered.
If we need guaranteed side effects, we should use AshOban, an extension
maintained by the Ash core team. AshOban creates a background job record in the
database as part of the action’s transaction. If the transaction rolls back, the job is
also rolled back. If it succeeds, Oban processes the job, tracks its status, and retries
on failure (for example, if the email service is down). This ensures the side effect
runs both "at most once" and "at least once," providing reliability for critical tasks.

12.3. How to create a simple working Ash Notifier?
To understand how Ash notifiers work, we can examine a practical example: the
ActivityLogger notifier. This notifier logs actions performed on our Project
resource, creating an audit trail for changes like creating, updating, or deleting
records. Below, we explain the code step-by-step, showing how it integrates with
Ash to handle notifications.

lib/tuesday/projects/project.ex
defmodule Tuesday.Projects.Project do
use Ash.Resource,
domain: Tuesday.Projects,
data_layer: AshPostgres.DataLayer,
authorizers: [Ash.Policy.Authorizer],
simple_notifiers: [Tuesday.Audit.ActivityLogger] ①
# ... other resource configuration ...
end

① We

configure

Project

resource

to

use

a

notifier

Tuesday.Audit.ActivityLogger
The notifier module itself is a simple one defined as shown below:

188

named

lib/tuesday/audit/activity_logger.ex
defmodule Tuesday.Audit.ActivityLogger do
use Ash.Notifier
def notify(%Ash.Notifier.Notification{
resource: resource,
action: %{type: action},
data: data,
actor: actor
}) do
resource_name = Ash.Resource.Info.short_name(resource)
params = %{
action: action,
target: "#{resource_name}:#{data.id}",
status: :success,
metadata: %{}
}
Tuesday.Audit.insert_log(params, actor: actor)
:ok
end
end

With this setup, all actions on our Project resource —except read actions—
trigger the ActivityLogger notifier, resulting in an audit log entry. Let’s break
down how it works:
1. We defined ActivityLogger with use Ash.Notifier, which requires us to
implement notify/1.
2. The notify/1 function pattern-matches on the Ash.Notifier.Notification
struct to extract resource, action, data, and actor. This ensures we only
process notifications with the expected structure. Ash will call the notify/1
function with this data structure whenever there is a change in Project
resource where this notifier is configured. What we do with this data is left
upto us to decide based on the business need.

189

In the example shown above, we make use of the information available from the
notification struct to insert a ActivityLog record. Have a look at the ActivityLog
module reproduced below in its simplest form.

lib/tuesday/audit/activity_log.ex
defmodule Tuesday.Audit.ActivityLog do
...
attributes do
uuid_primary_key :id
attribute :action, :string do
description "The type of action performed (e.g., create, update,
delete)."
...
end
attribute :target, :string
attribute :status, :atom do
description "The outcome of the action."
...
end
attribute :metadata, :map do
description "Additional context like IP address, changed fields,
etc."
...
end
attribute :actor_id, :uuid do
source :organization_member_id
end
create_timestamp :occurred_at do
description "The timestamp when the action took place."
...
end
end
end

190

Given the above attribute definitions in ActivityLog, we collect these information
in the notify/1 function and insert a record. We get the resource’s short name
(example, project) using Ash.Resource.Info.short_name/1 and create a
params map as input to our logger.
Ash notifiers skip read actions by default, as they don’t modify data and typically
don’t warrant side effects like logging.

12.4. What is PubSub Notification and how to configure it with Ash?
Dev Story
Chaaru works on an interesting feature in Tasks page of Tuesday.
When viewing a list of tasks in a project, the product team wants
the task list to be updated automatically behind the scenes without
the user refreshing the page if there is a new task created or an
existing task updated by some other user real time. Because
Tuesday doesn’t have an UI to test yet, she is also not sure how to
test it without a browser even if she learns how to do this.
The simple Notifier we created for ActivityLogger can be modified to meet
Chaaru’s needs. However, that is not the most natural way to do this in Ash. Ash
includes a built-in PubSub notification system that leverages Phoenix’s robust
notification mechanism. We will explore how to implement this to meet Chaaru’s
needs. In the next two follow-up questions, we will examine how to set up an
environment to experiment with this notification feature in Phoenix without Ash
and how to configure Ash to enable automatic notifications.

12.5. How to setup and test broadcast using IEx shells?
Before we can setup Ash.Notifier.PubSub for the Task resource, let’s first do a
test broadcast notifications from IEx shell manually to check everything works
correctly before we broadcast automatically through Ash.
We can use two IEx shells to simulate a distributed environment of a web app. One
shell subscribes to the PubSub topic, and the other shell triggers a broadcast
message to the same subscribed topic enabling the first shell to see this message.

191

Start the First IEx Shell (Node 1):
In a terminal, we start a named node with a shared cookie to enable clustering:
$ iex --name node1@127.0.0.1 --cookie test -S mix

Now, we verify the node name inside the iex shell.
iex> Node.self()

# Returns :node1@127.0.0.1

In Node 1, we will start creating a new Task resource which we then want to see
notified in Node 2.
Start the Second IEx Shell (Node 2):
In another terminal, we start a second node with the same cookie:
$ iex --name node2@127.0.0.1 --cookie test -S mix

We now have two nodes running our project Tuesday but they are not yet
connected.
We connect Node 2 to Node 1 to form a cluster using the following command on
Node 2’s IEx shell.

Connect Nodes 1 & 2 from Node 2
iex> Node.connect(:"node1@127.0.0.1")
iex> Node.list()

# Returns true

# Returns [:node1@127.0.0.1]

Node 2 act as the client which is subscribing itself to a specific topic and receives
messages on this topic. We can subscribe to the topic named "task" using the
following command.

Subscribe to topic from Node 2
iex> TuesdayWeb.Endpoint.subscribe("task")

192

iex> flush() # returns :ok

Every Phoenix app comes with this Endpoint module and it contains the
subscribe/1 function with which we can connect to a topic and listen for any new
messages to that topic. So now, Node 2 is subscribed and is ready to receive any
new messages on task topic. We also use iex helper function to see if there is any
new message. If there is any new message, the message is printed out otherwise just
:ok is returned.
We can quickly check if this is working properly by manually broadcasting a test
message from Node 1 usig the code below:
Broadcast from Node 1:
iex> TuesdayWeb.Endpoint.broadcast("task", "eventname", "payload from
Node 1")
:ok

broadcast/3 takes the topic name as the first argument, event as the second
argument and finally the payload as the third argument. Since we are listening on
topic named "task" on Node 2, we are broadcasting to this topic from Node 1. We
can verify the message as reached Node 2 by using the flush command on Node 2.

Receive the broadcast on Node 2
iex> flush
%Phoenix.Socket.Broadcast{topic: "task", event: "eventname", payload:
"payload from Node 1"}
:ok

Everything works in our broadcast and now we can test how to broadcast
automatically from Ash whenever a new task is created or an existing task is
updated.

12.6. How does Ash.Notifier.PubSub work in our Ash application for
broadcasting project creation?
Having seen how Node 1 and Node 2 interact with broadcasting and receiving

193

messages, we now want to automatically send a broadcast message, similar to
what we sent from Node 1, whenever a new Task is created. If we can achieve this,
the rest of the work consists of implementation details regarding how Chaaru
wants to display the newly created task to his users.
Let us configure Ash.Notifier.PubSub under the notifiers key in our resource
declaration, as highlighted below:

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects.Task do
use Ash.Resource,
domain: Tuesday.Projects,
data_layer: AshPostgres.DataLayer,
simple_notifiers: [Tuesday.Audit.ActivityLogger]
notifiers: [Ash.Notifier.PubSub]
# ... other resource configuration ...
end

This is different from the use of simple_notifiers key we used earlier for our
ActivityLogger. Simple notifiers don’t provide any special DSL for configuring
our resource like our ActivityLogger. The built-in Ash.Notifier.PubSub
notifier has special DSL to configure and hence we configure it under notifiers
key.

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects.Task do
# ... other resource configuration
pub_sub do
module TuesdayWeb.Endpoint
prefix "task"
publish :create_task, [[:id, nil]]
publish_all :update, [[:id]]
end
# ... other resource configuration ...
end

194

We will go through the explanation of this new DSL, but let us first test it in IEx
shell to appreciate that those four lines of configuration are all it takes to
automatically broadcast messages to three different topics for two different event
types.
The Task resource in the Tuesday project is already configured with this code, so
there is no need to add anything to this module or recompile. On the existing Node
1 terminal created in the previous section of this chapter, we can run the following
command to fetch a random project and create a new Task record in it.
Broadcast from Node 1:
# fetch a project
iex> project = Ash.read_first!(Tuesday.Projects.Project, authorize?:
false)
# Create a task using default `:create` action
iex> task101 = Ash.create!(Tuesday.Projects.Task, %{title: "Task 101",
project_id: project.id}, authorize?: false)
[debug] ...truncated sql query. NO DEBUG MESSAGE related to BROADCAST.

We create a new Task record but at this point there is no broadcast sent. This is
expected as we haven’t specified which action to use for the Task creation and Ash
used the default action :create.
In our configuration for the pub_sub, we have configured notification only for
:create_task action.

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects.Task do
# ... other resource configuration
pub_sub do
module TuesdayWeb.Endpoint
prefix "task"
publish :create_task, [[:id, nil]]
publish_all :update, [[:id]]
end
end

195

Now, let us create a new Task using the :create_task action explicitly using the
Domain Interface functions defined for :create_task. This is defined in
Tuesday.Projects domain as highlighted below:

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects do
use Ash.Domain,
otp_app: :tuesday
resources do
resource Tuesday.Projects.Task do
define :create_task
define :update_task
...
end
end
end

Using the :create_task action in IEx shell, we can see that it triggers a broadcast
to two topics as shown below:
iex> task102 = Tuesday.Projects.create_task(%{title: "Task 102",
project_id: project.id}, authorize?: false)
... Truncated result
[debug] Broadcasting to topics ["task:ade41b2f-...e627d", "task"] via
TuesdayWeb.Endpoint.broadcast

We can verify if the message is received on Node 2 using flush. Although the
create_task action triggered a broadcast to two topics, we are only listening to
one topic on Node 2, so we will receive only one message. It is up to the receiving
process to decide what to do with the notification, such as sending an email, adding
a log, or simply ignoring it if it is not interested in the message received.
Checking message on Node 2:
iex> flush()
%Phoenix.Socket.Broadcast{}

196

:ok

Now let’s update the previously created task using both the default :update action
and the code interface function defined for :complete_task action.
# Update the task using default `:update` action
iex> task102 = Ash.update!(task102, %{title: "Updated Task 102"},
authorize?: false)
... Truncated result
[debug] Broadcasting to topics ["task:ade41b2f-...e627d"] via
TuesdayWeb.Endpoint.broadcast
# Update the task using code interface linked with `:complete_task`
action
iex> task102 = Tuesday.Projects.complete_task!(task102, authorize?:
false)
... Truncated result
[debug] Broadcasting to topics ["task:ade41b2f-...e627d"] via
TuesdayWeb.Endpoint.broadcast

Again, let’s verify if the message is received on Node 2 using flush. This time we
got two broadcast notification corresponding to two updates.
Checking message on Node 2:
iex> flush()
%Phoenix.Socket.Broadcast{}
%Phoenix.Socket.Broadcast{}
:ok
iex>

Now, let’s explain what we have configured using the special pub_sub dsl and how
everything worked.

lib/tuesday/projects/task.ex
defmodule Tuesday.Projects.Task do
pub_sub do
module TuesdayWeb.Endpoint ①

197

prefix "task" ②
publish :create_task, [[:id, nil]] ③
publish_all :update, [:id] ④
end
# ... other resource configuration ...
end

The module macro specifies a module that implements the broadcast/3 function.
Since we are in a Phoenix app, which provides this module, we use
TuesdayWeb.Endpoint. Ash uses this module to send broadcast messages for the
events we configure.
The prefix macro customizes the topic name for configured events by prepending
the provided string. Ash generates the topic name using a template, which we will
explore next. For example, if the template yields "helloworld" and we set the prefix
to "task," the final topic becomes "task:helloworld".
The publish macro accepts two arguments and serves two purposes:
1. It configures the action name for which a broadcast message is sent. Here, we
set the action to create_task, an action defined in the Task resource. The
publish macro applies to individual actions, so only the :create_task action
triggers a broadcast message based on our configuration.
2. It defines the template for the topic name using the second argument, a nested
list. For clarity, consider a different template: [:id,

:project_id,

:priority]. This template, formatted as [a, b, c], uses attributes from the
task record. Ash generates the topic as task:a:b:c, such as task:id-ofthe-task:project-id-of-task:priority-of-task, for changes in these
attributes.
To make a placeholder optional, we can use a nested list like
[a, b, [c, nil]]. This generates both task:a:b:c and
task:a:b, making c optional. Note that a, b, and c are
illustrative; valid values are either literal strings or atoms
representing fields in the resource.

198

Finally publish_all macro does the same as publish, except that it takes in an
action_type instead of an action. publish_all

:update ensures that

notification is triggered for all actions of type :update.
Given the above explanation, we now have the puzzles sorted out on why our code
behaves the way we have seen in the iex shell.
The

reason

Ash.create!

call

didn’t

trigger

any

notification

but

Tuesday.Projects.create_task did send trigger notification is because we have
explictly allowed notification for :create_project action and not all :create
action types.
The

reason

both

Ash.update!

and

Tuesday.Projects.complete_task!

triggered notification is because both are using the action type :update and we
have allowed all actions of type :update.
Finally, when we create a new task we want the :id to be optional in the topic
name and hence we got two topic variations for create: task and task:uuid-oftask.
iex> task102 = Tuesday.Projects.create_task(%{title: "Task 102",
project_id: project.id}, authorize?: false)
... Truncated result
[debug] Broadcasting to topics ["task:ade41b2f-...e627d", "task"] via
TuesdayWeb.Endpoint.broadcast

However, for :update actions we do not want any optional placeholder and hence
we always get task:uuid-of-task.
# Update the task using default `:update` action
iex> task102 = Ash.update!(task102, %{title: "Updated Task 102"},
authorize?: false)
... Truncated result
[debug] Broadcasting to topics ["task:ade41b2f-...e627d"] via
TuesdayWeb.Endpoint.broadcast
# Update the task using code interface linked with `:complete_task`
action

199

iex> task102 = Tuesday.Projects.complete_task!(task102, authorize?:
false)
... Truncated result
[debug] Broadcasting to topics ["task:ade41b2f-...e627d"] via
TuesdayWeb.Endpoint.broadcast

We have so far subscribed and handled notification directly in IEx. However,
notification being a highly web related functionality, here is what you might do in
your LiveView layer to subscribe to a topic and to handle the message. This part is
similar to our Node 2 IEx shell which was subscribing and receiving messages.
# In the `mount/3` inside a LiveView, we could connect to a topic as
below
if connected?(socket) do
TuesdayWeb.Endpoint.subscribe("task")
end
# Elsewhere in the same module, define a handle_info to handle the
incoming message
def handle_info(%{topic: "task", event: "create", payload:
notification}, socket) do
# Do something with the notification like reloading the tasks
tasks = reload_tasks()
{:noreply, assign(socket, tasks: tasks)}
end

12.7. Summary
The chapter explored Ash Notifiers, mechanisms for reacting to resource changes
(e.g., create, update, delete), using the Tuesday application’s Project and Task
resources as examples. Below are the key concepts covered.

12.7.1. Key Concepts
• Notifier Overview: Ash Notifiers handle side effects like logging and emails
after successful transaction commits. Configured via simple_notifiers or
notifiers, they differ from action hooks, which may use uncommitted data
and suit failed actions. Notifiers, "at most once," fit non-critical tasks but lack
guaranteed delivery for critical side effects, where AshOban ensures reliability

200

with retryable jobs.
• Simple Notifier Example: The custom Tuesday.Audit.ActivityLogger
notifier logs non-read actions on a Project resource. It implements notify/1,
extracts data from` Ash.Notifier.Notification`, and inserts audit logs using
Tuesday.Audit.insert_log/2.
• PubSub Notifier: Ash.Notifier.PubSub enables real-time broadcasting for
actions like task creation or updates via Phoenix PubSub. Configured in a
pub_sub block, it uses publish or publish_all to define actions and topics

201

Chapter 13. Policies

13.1. What is a Resource Policy?
Policies are used to control access to resources. We can authorize or restrict access
to perform an action, access an attribute, aggregate, or calculation. Central to this
authorization policy is the actor who is performing the action in most cases, but a
policy can also be defined without involving an actor. For example, we could define
a policy to ensure only admins can delete a project, which involves an actor, or a
policy stating that a post can be viewed as long as its status is published, which
depends only on the resource’s attribute and not on an actor.
To define policies in our resource, we need to add the following option to the use
macro of the resource:
defmodule App.Domain.Resoure do
use Ash.Resource,
authorizers: [Ash.Policy.Authorizer]
...
end

Once we’ve added the authorizers extension to the use macro, we can define
policies in our resource. Shown below is an example policy block from User
resource in Tuesday based on Chaaru’s requirements:

Dev Story
Chaaru looked at all the required authorization rules in Tuesday
given by the business team and all of them required an
authenticated user to be present and along with a certain
conditions to be met. However for registering a new account, she
obviously needs to check that there is no current user set.
For now, to meet Chaaru’s requirements, think of current_user record

202

representing the authenticated user as the actor. However, an actor could be
some other record associated with the authenticated user as well.

lib/tuesday/auth/user.ex
defmodule Tuesday.Auth.User do
use Ash.Resource,
domain: Tuesday.Auth,
data_layer: AshPostgres.DataLayer,
authorizers: [Ash.Policy.Authorizer]
policies do
policy action(:register_user) do
authorize_if actor_absent()
end
policy action(:update_user) do
authorize_if expr(id == ^actor(:id))
end
end
...
end

Policies are defined under the policies block of the resource. Each policy needs to
be defined using the policy macro inside the policies block. The argument to the
policy macro is a condition that needs to be met in order to enforce the policy. In
the example shown above, we have the argument action(:register_user) and
action(:update_user) passed as argument for first and second policy
respectively.
General syntax of a policy macro is
policy condition do
authorize_if check
forbid_if check
# ... other policy statements
end

203

Most commonly used condition in policy definition are
action(:action_name)
Applies to a specific action (e.g., action(:read)).
action_type(:type)
Applies

to

all

actions

of

a

given

type

(e.g.,

action_type(:read),

action_type(:create)).
actor_attribute(:field, value)
Checks if the actor’s attribute matches a value (e.g., actor_attribute(:role,
:admin)).
relates_to_actor_via(:relationship)
Applies if the resource is related to the actor via a relationship (e.g.,
relates_to_actor_via(:author)).
always()
A catch-all condition that applies the policy to all requests. We can also omit the
condition and define a policy with no condition as in policy do…end and it’s
same as defining policy always()… end.
List of all the built-in checks like the above one can be referred to in the official Ash
Policy docs.
Once the Ash.Policy.Authorizer extension is included, every
request to read or modify the data must have at least one matching
policy. If there is no matching policy, the request is automatically
forbidden.
In the above definition of policy for User resource, we have defined two policy
matching two actions: register_user and update_user.

lib/tuesday/auth/user.ex
defmodule Tuesday.Auth.User do

204

policies do
policy action(:register_user) do
...
policy action(:update_user) do
...
end
end

However, there are four other default actions :create, :read, :update, :destroy
and since there are no matching policies for these actions, they will be defined
automatically. Let’s see this in action in IEx shell.
iex> Ash.create!(User, %{email: "chaaru@example.com"})
** (Ash.Error.Forbidden)
Bread Crumbs:
> Error returned from: Tuesday.Auth.User.create
Forbidden Error
* forbidden

However, if we pass authorize?: false, which is a manual way of overriding the
policy checks, then the same action is allowed:
iex>

Ash.create!(User, %{email: "chaaru@example.com"}, authorize?:

false)
#Tuesday.Auth.User<
__meta__: #Ecto.Schema.Metadata<:loaded, "users">,
id: "f589cff2-a430-4c0a-b402-adfa41d3d071",
...

So far, we have understood the outer structure of policy macro:
policy condition do
authorize_if check
forbid_if check
# ... other policy statements
end

205

Now, let’s see what the inner-block of the policy does:
Within the do-end block of the policy, we define something called checks. There
are 4 kinds of checks that we can define:
1. authorize_if - This is used to authorize the action if the condition is met
2. authorize_unless - This is used to authorize the action if the condition is not
met
3. forbid_if - This is used to forbid the action if the condition is met
4. forbid_unless - This is used to forbid the action if the condition is not met
Let’s see an example of a policy that matches all requests and also authorizes the
request at all times:
policies do
policy always() do
authorize_if always()
end
end

The first always() to the policy ensures that the policy is always applied to all
actions. The second always() passed to authorize_if ensures that this policy
always allows the action.
The policy macro has a condition checks if a policy is applicable to
a request. All request must have one matching policy, otherwise,
they are automatically rejected.
Within the policy macro, there can be multiple checks with one of
the 4 options: authorize_if, authorize_unless, forbid_if and
forbid_unless. Each of these 4 checks can return true, false or
:unknown.
Assuming we’ve multiple checks in our policies, from top down, if the first check is
met, then the other checks are not executed. If the first check is not met, then the

206

second check is executed and so on. If none of the checks are met, then the action is
forbidden. We’ll see many examples throughout this section of policies.

Dev Story
Chaaru

has

seen

these

checks

like

actor_present

and

actor_absent but she is wondering what are these actually? She is
working on Tuesday without Ash expertise and relies on forum
support and blog posts from community to help him. She feels
uncomfortable to add a snippet like actor_present purely based
on a random blog post’s recommendation on the internet, without
knowing what it actor_present and what it actually does . What
else can be in its place? How many of those things are there? What
if none of those checks suit his need?
These are common questions that we have found ourselves facing when learning
Ash policies and have heard this in our trainings. Let’s go through these questions
one by one.

13.2. What are Policy Checks?
What is this thing actor_present actually, that we use in Policy Checks like
authorize_if?
actor_present and actor_absent are helper functions defined by Ash in the
Ash.Policy.Check.Builtins module. These are standard Elixir functions that
become available (automatically imported through macros) in our resource
modules because we include the authorizers:

[Ash.Policy.Authorizer]

extension in our resource.
If we inspect the source code of these helper functions, we can see that they are
simple functions acting as syntactic sugar, returning a module name or a tuple.

lib/ash/policy/check/built_in_checks.ex
def actor_present do
Ash.Policy.Check.ActorPresent
end

207

def always do
{Ash.Policy.Check.Static, result: true}
end

This reveals that all checks are internally defined by an Elixir module. So in
essence, each of the 4 policy check types that we have seen earlier only requires a
module name or a tuple with two elements, where the first element is again a
module name and the second one is the options given to the functions defined in
the module.
So the following statements does exactly the same:
# Using syntactic sugar
authorize_if actor_present()
# Using naked syntax
authorize_if Ash.Policy.Check.ActorPresent

# Using syntactic sugar
authorize_if always()
# Using naked syntax
authorize_if

{Ash.Policy.Check.Static, result: true}

This also means that if we need to implement a custom check which is not built in
Ash, we can always define our own module to do the checks. We will see how to
define a custom check module later in this chapter but we before that, let’s take a
look at the different built-in policy checks available in Ash.

13.3. What are the different Policy Checks available?
Similar to actor_present or always that we have seen earlier, Ash defines several
other helper functions as listed below. Reproduced from official docs with easy
grouping to understand the different use cases covered.
1. Action-Based Checks
These functions relate to checking the action or action type being performed.

208

action(action)
Checks if the action name matches the provided action name(s).
action_type(action_type)
Checks if the action type matches the provided type.
just_created_with_action(action_name)
Checks if the resource was just created with the specified action.
2. Actor-Based Checks
These functions focus on the presence, absence, or attributes of the actor
performing the action.
actor_absent()
Returns true if no actor is specified, false otherwise.
actor_present()
Returns true if an actor is specified, false otherwise.
actor_attribute_equals(attribute, value)
Checks if the actor’s specified attribute equals the given value.
3. Resource and Relationship Checks
These functions deal with the resource, its relationships, or how the action is
performed through relationships.
resource(resource)
Checks if the resource name matches the provided resource name(s).
accessing_from(resource, relationship)
Checks if the action is being performed through a specific relationship.
relating_to_actor(relationship)
Checks if the specified relationship is being changed to the current actor.

209

relates_to_actor_via(relationship_path, opts \\ [])
Checks if the data relates to the actor via a specified relationship or path.
changing_relationship(relationship)
Checks if the specified relationship is changing.
changing_relationships(relationships)
Checks if the specified relationships are changing.
4. Attribute and Field Checks
These functions focus on attributes, fields, or selections in the query or
changeset.
changing_attributes(opts)
Checks if attribute changes match the provided options.
selecting(attribute)
Checks if the specified field is being selected.
loading(field)
Checks if the specified field or relationship is being loaded.
5. Context-Based Checks
These functions evaluate the context of the query or changeset.
context_equals(key, value)
Checks if the value of a specified key or path in the context equals the given
value.
6. Custom and Universal Checks
These functions provide flexible or universal checks that don’t fit neatly into
other categories.
matches(description, func)
Evaluates a custom function and returns true if it passes.

210

always()
Always passes, regardless of conditions.
never()
Never passes, regardless of conditions.

13.4. What is an actor and how to set it?
Dev Story
Chaaru is familar with the concept of current_user in a web
request which is normally mapped to the authenticated user
through tokens. She reads through the Ash Policy docs and
understands setting up actor is central to authorization policies
but it’s not clear if Ash calls the currently authenticated user as the
actor or is it something else. In Tuesday, she has User resource
mapping to the currently authenticated user but this user can be
related to multiple organization which makes it tricky to assume
the user as the actor.
Chaaru is right. Since a logged in user can be member of multiple workspaces, it’s
not efficient to use User record as the actor. But why? This can become obvious if
we look at some of the actual policies that we want to write in Tuesday.
1. Only organization admin can add new project within the organization.
2. All members of a project can create tasks within the project.
3. Only admin of a project can delete a task comment.
If we analyse these requirements, the actor who is being checked are
1. organization admin
2. members of a project
3. admin of a project
Let’s ask the question how easy is to check these conditions from user record.

211

For the first check, we can ofcourse do these checks through user but this require
us to join the organization_members and the users table and then specifically
checking the role of the current user in the organization where the action is being
performed.
For the other two checks, we need to join 3 different tables: users,
organization_members and project_memberships table to check if the current
user has the required role in the project. Ideally, for the actor we want to use a
resource that is having the least number of joins to check the permissions for the
vast majority of our use cases. This gives us better performance, easier to reason
about and write policies quickly.
In this case, OrganizationMember record is a better match than User record
because it already has the organization ID data and the role of the member which
solves most of our checks without any additional joins. For checks to see the role of
the actor in specific project, it’s just 1 join with the ProjectMembership.
Hence for Tuesday we are relying on the OrganizationMember as the Actor. Let’s
say User A is a member of two organizations OrgA and OrgB, then when the user A
signs in, we show them their default workspace, let’s say OrgA, and allow the user A
to switch to OrgB. As long as the User A is in the workspace of OrgA, we have the
OrgA-member record of the user as the actor. If the user switches to OrgB, then we
also change the actor to OrgB-member record of the user. This ensures that we
always check against the appropriate permission associated with the current
workspace.

Dev Story
Additionally, we have the added benefit of retrieving the tenant
information from the actor itself if we use OrganizationMember as
the actor. We will touch upon the use of tenant in the chapter on
Multitenancy.
Assuming we are using Phoenix along with Ash, we could set the actor using Plug
helpers Ash.PlugHelpers.set_actor/2 in the router or controller pipelines
using plugs.

212

The following code doesn’t exist in Tuesday but is shown here as an example of
how you can create a plug and use with Phoenix to set and retrieve the actor
information.
# lib/my_app_web/plugs/set_current_user.ex
defmodule MyAppWeb.Plugs.SetCurrentUser do
import Plug.Conn
alias Ash.PlugHelpers
def init(opts), do: opts
def call(conn, _opts) do
# Assume the user token is stored in the session
user_token = get_session(conn, :user_token)
# Fetch the user from the database (or your authentication logic)
user = MyApp.Auth.fetch_user_by_token(user_token)
# Set the actor using Ash.PlugHelpers.set_actor
Ash.PlugHelpers.set_actor(conn, user)
end
end

The plug can then be used in the app router.ex as shown below:
# lib/my_app_web/router.ex
defmodule MyAppWeb.Router do
use Phoenix.Router
pipeline :browser do
# Existing plugs
plug MyAppWeb.Plugs.SetCurrentUser # Add the plug here
end
scope "/", MyAppWeb do
pipe_through :browser
get "/posts", PostController, :index
end
end

213

Then finally, when we want to call Ash functions in Phoenix Controller, fetch the
actor and pass it to the Ash function manually.
# lib/my_app_web/controllers/post_controller.ex
defmodule MyAppWeb.PostController do
use Phoenix.Controller
alias Ash.PlugHelpers
def index(conn, _params) do
# Retrieve the actor (current user)
current_user = Ash.PlugHelpers.get_actor(conn)
# Use the actor to query posts with Ash
posts = MyApp.Blog.list_posts(actor: actor)
# Render the posts
render(conn, "index.html", posts: posts)
end
end

13.5. How do I authorize an action based on a specific attribute of
the actor?
Dev Story
Tuesday has a requirement that only organization members who
have their role set to :owner can update the organization using the
actions change_org_plan or update_org. Chaaru wants to
implements this requirement as a policy check.
We have already seen that the OrganizationMember record is configured as the
actor in the Tuesday project. Therefore, we need a way to check the attributes of the
actor.
In the previous topic, we saw how actor_present is used to authorize an action
based on the presence of an actor. Here, however, we want to authorize an action
based

on

a

specific

attribute

of

the

actor_attribute_equals, as shown below:

214

actor.

This

can

be

done

using

lib/tuesday/workspace/organization.ex
policy action(:change_org_plan) do
forbid_unless relates_to_actor_via(:organization_members)
authorize_if actor_attribute_equals(:role, :owner)
end

The actor_attribute_equals function takes two arguments. The first one is the
name of the attribute present in the actor resource and the second one is the value
of the attribute. We also have relates_to_actor_via as an additional condition
which we will see in the next question.

13.6. What is the difference between relating_to_actor and
relating_to_actor_via?
Dev Story
Chaaru

understands

that

actor_attribute_equals(:role,

:owner) is what she needs to check if the actor is having :owner
role but this doesn’t satisfactorily answer the question if the actor is
a member of the organization which is being updated? The actor
can have a :owner role in some other organization and may not be
even a member of the organization being updated and we want to
block

such

actions.

Chaaru

sees

two

helper

functions

relating_to_actor and relating_to_actor_via that seems
like doing this check but she cannot understand the difference
between them.
Naming things is a hard problem in computer science. It needs to be short and crisp
and yet meaningful. This is not always possible and we feel one such example is the
difference between these seemingly similar functions.
Both of these two functions check if the record is being associated with the actor in
some way. However, there is an important difference:
1. relating_to_actor_via checks if the current record is related to the actor
via a specified relationship path.

215

2. relating_to_actor check if the record which is currently being created or
updated is making a relationship connection to the actor in its final form.
Put in other way,
1. relating_to_actor_via does not consider the changes being made. It checks
the existence of the relationship to the actor in the record. A hypothetical
alternative name could be record_relates_to_actor_via.
2. relating_to_actor is highly concerned with the changes being made. It
examines the currently proposed changes in the Ash.Changeset of the action
with respect to the relationship to the actor. A hypothetical alternative name
could be changeset_relates_to_actor_via.
In the use case for the Tuesday project, we are interested in the record’s association
with the actor and not in the changeset. relates_to_actor_via along with
actor_attribute_equals is what we need. Below is the code snippet from the
Organization policy check for our reference.

lib/tuesday/workspace/organization.ex
policy action(:change_org_plan) do
forbid_unless relates_to_actor_via(:organization_members)
authorize_if actor_attribute_equals(:role, :owner)
end

13.7. What is a Policy Group?
Dev Story
Chaaru wants to organize write policies for the Project resource’s
actions based on the actor’s association with the organization and
the project, creating a hierarchical structure for permission groups.
For example, she wants to allow access to owner or admin of the
organization even if they are not members of a project but deny
access to a standard member of the organization if they are not a
member of the project as well. She wants the permissions grouped
and nested for clarity and maintainability.

216

The policy_group macro helps us define nested policies where each matching
policy in the hierarchy must be fulfilled. For example, the following snippet from
Project resource in Tuesday shows how one such nested policies can be defined.
defmodule Tuesday.Projects.Project do
policies do
policy action(:create_project) do
authorize_if Tuesday.Checks.ActorCreateProject
end
policy_group relates_to_actor_via([:organization,
:organization_members]) do
policy action_type(:update) do
authorize_if actor_attribute_equals(:role, :owner)
authorize_if actor_attribute_equals(:role, :admin)
forbid_unless relates_to_actor_via([:project_members,
:organization_member])
authorize_unless {Tuesday.Checks.IsProjectMemberRole, role:
:standard}
end
policy action_type(:read) do
authorize_if actor_attribute_equals(:role, :owner)
authorize_if actor_attribute_equals(:role, :admin)
authorize_if relates_to_actor_via([:project_members,
:organization_member])
end
end
end
end

13.8. What is a Policy Bypass and when to use it?
If we look at the previous policies for Project resource, we could simplify it with
bypass because if we identify the actor as the :owner of the current organization,
we probably don’t want to check anything else and want to allow all actions.
defmodule Tuesday.Projects.Project do
policies do

217

bypass relates_to_actor_via([:organization, :organization_members])
do
authorize_if actor_attribute_equals(:role, :owner)
authorize_if actor_attribute_equals(:role, :admin)
end
policy action(:create_project) do
authorize_if Tuesday.Checks.ActorCreateProject
end
policy_group relates_to_actor_via([:project_members,
:organization_member]) do
policy action_type(:update) do
authorize_unless {Tuesday.Checks.IsProjectMemberRole, role:
:standard}
end
policy action_type(:read) do
authorize_if always()
end
end
end
end

In the modified code above, we simplified the policy_group by using a bypass. In
the bypass, we check if the current actor is associated with the project’s
organization. If so, we verify whether the actor has the :owner or :admin role and
authorize the action in either case. As a bypass check, this policy takes precedence,
allowing the action without evaluating other policies if the bypass passes. This
eliminates the need to define policies for all actions within this policy_group for
owners and admins, which we would otherwise have to specify.

13.9. How to create a Custom Policy Check?
Dev Story
Chaaru has the following requirements in Tuesday.
1. Only logged in user must create project. Anonymous user

218

should be denied to create project.
2. A logged user’s organization must match the organization
where they are trying to create a project. i.e., A member cannot
create projects in another organization even if they are a
member of any other organization. And they must qualify
either of the conditions below:
a. A member of the project with standard role can create
project only if the organization setting allows people with
standard role to create projects in their organization.
b. If the organization’s setting doesn’t allow the standard
role to create projects, then only the owner or admin role
members can create a project in their organization.
He feels that none of the existing policy checks in Ash can meet
these requirements as a whole.
Custom Policy Check comes in handy when there is no existing built-in policy
checks that matches our need or it feels too complex to add a bunch of built-in
checks in a single policy.
Since this is a create action for a Project, the only available records during
creation are the OrganizationMember, who is the actor performing the action, and
the Organization they are a member of. Input for creating the project comes from
the actor, but it is not yet stored in the database. Therefore, we cannot use database
references for the project data here.
We will first start defining the policy for the Project resource like below:
policies do
policy action(:create_project) do
authorize_if Tuesday.Checks.CreateProject
end
end

This policy is for a specific action named :create_project which is already
defined in the resource. Because we cannot establish the condition using references

219

to the project data which is normally the case for all create actions, we are using a
Custom Check module named Tuesday.Checks.CreateProject which is given
below:
defmodule Tuesday.Checks.CreateProject do
use Ash.Policy.SimpleCheck
def describe(_) do
"""
Base condition: Actor's org_id and the intended project's org_id
are same
This base condition is mandatory for all the other checks.
In addition to the base condition bring true, at least one of the
following conditions
must be true to allow creating project:
1. Actor role is `:owner`
2. Actor role is `:admin`
3. Actor role is `:member` and Actor organization's
`can_member_create_project` is true
"""
end
def match?(nil, _, _), do: false
def match?(%{role: actor_role, organization_id: actor_org_id} =
_actor,

%{changeset: changeset}, _opts) do

project_org_id = Ash.Changeset.get_attribute(changeset,
:organization_id)
org = Ash.get!(Tuesday.Workspace.Organization, actor_org_id)
allow_standard_role_project = org.can_member_create_project
allow_project_creation?(actor_role, actor_org_id, project_org_id,
allow_standard_role_project)
end
defp allow_project_creation?(:owner, org_id, org_id, _), do: true
defp allow_project_creation?(:admin, org_id, org_id, _), do: true
defp allow_project_creation?(:member, org_id, org_id, true), do: true
defp allow_project_creation?(_, _, _, _), do: false

220

end

We have the describe function which serves as a documentation for this policy
when any error appears in the policy.
All custom policy checks must implement match?/3 function and it should return a
boolean value. As you can see we are leveraging Elixir’s function head pattern
matching feature to define our checks in an idomatic manner. This is a common
pattern in Ash and it makes our policy very easy to read.
Let’s go through our requirements and match it with the associated code in our
module.
Requirement 1: Only logged in user must create project. Anonymous user should be
denied to create project.
This is the most easiest policy to define. When there is no actor, we need to deny.
The match?/3 function takes in three arguments:
1. actor
2. changeset
3. context
So if the first argument actor is nil, then we don’t care about the rest of the
arguments. We can immediately return false which will deny the request. This is
exactly what we do in our first match clause
def match?(nil = actor, _changeset, _context), do: false

So far so good. For the other requirements, let’s understand what data we need and
where to find them.
Requirement 2: "A logged user’s organization must match the organization where
they try to create a project."
This means that we first need to figure out the organization_id of the current actor

221

and we also need the organization_id of the incoming new project data which is not
yet inserted. Let’s call these two data as actor_org_id and project_org_id.
Requirement 3: "A member of the project with standard role can create project only
if the organization setting allows people with standard role to create projects in it."
We also need to know the role of the current actor and the organization’s setting for
can_standard_member_create_project. Let’s call these two data as actor_role
and allow_standard_role_project
Requirement 4: "If the organization’s setting doesn’t allow the standard role to
create projects, then only the owner or admin role members can create a project in it."
We again need the actor’s role which we already have. Admin or owner can create
project irrespective of the organization settings. So we don’t need any other data.
We will first get the four data points and once we have them, we can play again
with the Elixir’s pattern matching function to write our condition in an elegant
way.
We can get actor_role and actor_org_id from pattern matching on the actor
argument passed to the match/3 function.
%{role: actor_role, organization_id: actor_org_id} = _actor

You can see this code in the function head of match/3 above.
Now we need to get the project_org_id. This is present in our user’s input
alongside the project information. The second argument changeset passed to
match/3 contains all the information about the data that is going to be inserted.
project_org_id = Ash.Changeset.get_argument(changeset, :organization_id)

The above code fetches the organization_id from the user input.
Finally,

we

need

to

find

out

the

organization’s

setting

for

can_standard_member_create_project. However, there are two organizations

222

now.
1. The organization of the actor.
2. The organization for which the project is to be created.
In an ideal scenario, the above two should be the same. However, the user can
accidentally or with malacious intent can try to create project for another
organization as well. And the settings for these two organization can be different.
org = Ash.get!(Tuesday.Workspace.Organization, actor_org_id)
allow_standard_role_project = org.can_member_create_project

The above code gets the organization settings of the actor instead of the
organization where they intent to create a project. This can seem like a wrong thing
to do but we are addressing that shortly.
With all the four data points in place, the magic happens with this function call:
allow_project_creation?(actor_role, actor_org_id, project_org_id,
allow_standard_role_project)

We are having 4 different pattern matching function heads for the above call.
defp allow_project_creation?(:owner, org_id, org_id, _), do: true
defp allow_project_creation?(:admin, org_id, org_id, _), do: true
defp allow_project_creation?(:member, org_id, org_id, true), do: true
defp allow_project_creation?(_, _, _, _), do: false

First, we have org_id repeated for both 2nd and 3rd argument of the function.
Because of how Elixir’s pattern matching works, this ensures that both the
actor_org_id and the project_org_id to be verified as one and the same. If they are
not, the pattern match fails and it leads to the fourth clause that returns false.

13.10. Summary
The chapter explored Ash Resource Policies, which control access to resources,
actions, attributes, aggregates, and calculations, using the Tuesday application’s

223

User, Organization, and Project resources as examples. Below are the key
concepts covered.

13.10.1. Key Concepts
• Policy Overview: Policies control access based on actors or resource attributes,
requiring a matching policy for every request to avoid being forbidden.
• Policy Structure: The policy condition macro defines conditions like
or

action(:name)

always(),

with

sequential

checks

(authorize_if,

forbid_unless) determining access based on true, false, or :unknown
outcomes.
• Built-In Policy Checks: Ash.Policy.Check.Builtins offers checks for
actions

(e.g.,

action(:name)),

actors

(e.g.,

actor_present()),

resources/relationships (e.g., relates_to_actor_via(:path)), attributes,
context, and custom cases (e.g., always()).
• Authorizing

by

Actor

Attributes:

actor_attribute_equals(:field,

value) checks actor attributes, often paired with relates_to_actor_via(:path) to
confirm resource association like organization membership.
• Relating_to_actor vs. Relates_to_actor_via:
relating_to_actor(:relationship) checks changeset relationship changes
to

the

actor,

while

relates_to_actor_via(:path)

verifies

existing

record

relationships, ignoring changes.
• Policy Groups: policy_group condition nests policies for hierarchical
authorization, such as grouping project access rules under action relationships
conditions.

224

Chapter 14. Multitenancy

14.1. What is a tenant?
In SaaS, a tenant is an entity paying to use software without owning it, akin to a
renter in property terms. For Tuesday, a B2B project management tool, each
organization record is a tenant, as they pay for their team members’ access. In B2C
apps, a tenant might be an individual user, but this depends on business decisions.
Technically, a tenant is any record grouping others with a strong database
boundary, like an organization_id linking related data in Tuesday.

Dev Story
Tuesday is a SaaS platform, available for organizations to sign up
and use for a monthly fee, similar to Jira, Basecamp, or Slack.
Securely isolating workspace data for different organizations and
billing them accurately is a critical requirement. Chaaru wants to
ensure that she doesn’t accidentally leak data of one tenant to
another.
Chaaru could implement multitenancy by manually querying every resource, such
as

Project,

with

a

filter

like

where

organization_id

==

current_user.organization_id, to fetch only the logged-in user’s organization
data. However, under time pressure, there is a risk of forgetting this filter when
adding new features. Relying solely on developers to never make mistakes is
unsustainable.

We

need

a

robust

mechanism

to

enforce

data

isolation

automatically, preventing errors.
Ash’s built-in Multitenancy feature solves this problem. It is Ash’s standard
approach to isolating data for different tenants within a single application,
ensuring privacy and safety. This feature is essential for SaaS platforms like the
Tuesday project, where data leaks could compromise trust or compliance.

225

14.2. Enabling Multitenancy in Tuesday
To enable multitenancy in Tuesday, we first identify the tenant resource. In our
app, the Organization resource acts as the tenant, representing each company
using our SaaS platform. Resources like OrganizationMember and Project relate
directly to Organization through the organization_id foreign key.
To make these resources tenant-aware, we add this configuration to their resource
module:
multitenancy do
strategy :attribute
attribute :organization_id
global? true
end

This setup enables multitenancy for the resource. The :attribute strategy directs
Ash to automatically filter queries by organization_id, ensuring data isolation
for the specified tenant across all CRUD operations. For example, querying Project
returns only records matching the current tenant’s organization_id. Similarly,
creating a new Project requires setting the mandatory tenant ID in the
organization_id column.
The multitenancy block supports several key options. The strategy option
accepts either :attribute or :context. We currently use :attribute, which
mandates the attribute configuration under multitenancy, specified as
organization_id. This approach uses a single set of tables for all tenants, making
it efficient for relational databases like PostgreSQL. Alternatively, the :context
strategy isolates tenant data using database schemas instead of an attribute in each
table.

Why global? true?
It depends on the business use case. For Tuesday, we wanted to
make it easy for readers to try the functions discussed in the book
without excessive complexity. Setting global?

true allows

records to be created or read without enforcing multitenancy. This
enables readers to explore the multitenancy feature while also

226

working with Tuesday as if multitenancy were not configured. In
your own project, you should evaluate whether global? true is
necessary.

14.3. Making Indirectly Related Resources Multitenant-Aware in
Tuesday
In Tuesday, resources like Task and ProjectMember are indirectly related to the
Organization tenant through another resource, such as Project. To ensure
robust multitenancy, we recommend adding an organization_id foreign key
directly to these resources’ tables, even though the tenant could be inferred via
joins (e.g., from Task to Project to Organization). Although Ash doesn’t require
this, we believe it provides significant benefits in terms of security and simplicity.
To make Task or ProjectMember multitenant-aware, we configure them like other
tenant-aware resources:
multitenancy do
strategy :attribute
attribute :organization_id
end

This setup ensures Ash filters queries and sets organization_id on creates or
updates, isolating data to the correct tenant without relying on joins.
The usual argument against adding organization_id to all indirectly related
resources are
1. Risk of Bugs: Mismatched tenant IDs could lead to errors or data leaks.
2. Unnecessary Complexity: Managing extra foreign keys adds development
overhead.
3. Redundancy and Normalization: Duplicating organization_id violates
database normalization principles. For example, if a task belongs to a project
that already has an organization_id, why should task also have
organization_id as a duplicate?

227

Let’s address the validity of these one by one in the context of Ash Multitenancy:
1. Risk of Bugs: Ash Multitenancy eliminates most risks of bugs related to
mismatched or incorrect tenant identifiers by enforcing tenant scoping at the
framework level. It ensures that organization_id is consistently set and
queried, invalidating this concern.
2. Unnecessary Complexity: Ash abstracts away the complexity of managing
tenant identifiers, making it seamless to include organization_id in child
tables. Developers don’t need to manually handle tenant logic, so this point is
largely irrelevant.
3. Redundancy and Normalization: While adding organization_id to all
tables introduces some redundancy and deviates from strict normalization, this
is indeed more of a "puritan" concern in the context of Ash. The practical
benefits—faster queries without joins and stronger tenant isolation for
security—outweigh these theoretical drawbacks, especially since Ash ensures
data consistency. The advantage of ensuring no data leak and faster query is
far more superior and important than sticking to the principe of normalization
here.
By including organization_id in Task and ProjectMember, we achieve seamless
multitenancy, prioritizing data safety and query efficiency over theoretical
database ideals.

14.4. How to set the Tenant for CRUD Operations in Tuesday?
Ash offers multiple ways to perform CRUD operations, each adaptable to
multitenancy for tenant-aware data access. For reading projects, we can use:
1. Ash.read!/2: Directly query a resource.
2. Ash.Query.for_read/3: Build a query for reading.
3. Domain code interface: Use domain-specific functions like list_projects/1.
Without multitenancy, these methods list all projects in the system. Similarly, for
create, update, or delete operations, we have:
1. Ash.create!/3: Create a record directly.

228

2. Ash.Changeset.for_create/4: Build a changeset for creation.
3. Domain code interface: Use functions like create_project/2.
Once we configure the Project resource for multitenancy with the :attribute
strategy and organization_id, Ash ensures all CRUD operations respect the
tenant, isolating data to the specified organization. And if we don’t specify the
tenant, these operations will fail with an error message.
Let’s fetch an organization record representing the tenant from Tuesday’s
dataset:
# Get an organization from the database
organization = Tuesday.Workspace.Organization
|> Ash.read!(authorize?: false)
|> List.first()

14.4.1. Using Tenant in Ash.func
We will take the example of a read and create action using Ash.read and
Ash.create.

The

same

method

would

also

apply

for

and

Ash.update

Ash.destroy.
# Instead of this, which lists all projects:
Ash.read(Tuesday.Projects.Project, authorize?: false)
# Use this to list projects for the organization:
Ash.read(Tuesday.Projects.Project, tenant: organization.id, authorize?:
false)

For Ash.create!/3:
params = %{name: "Project Name", end_date: ~D[2025-05-09]}
# Instead of this:
Ash.create(Tuesday.Projects.Project, params, action: :create_project,
authorize?: false)
# Use this:

229

Ash.create(Tuesday.Projects.Project, params, action: :create_project,
tenant: organization.id, authorize?: false)

Both Ash.read/2 and Ash.create/3 are powerful functions offering numerous
configuration options. The Ash.create/3 function accepts opts as the second
argument when no parameters are provided or as the third argument when
params is included. The opts keyword list includes several configuration options,
and we use the tenant option here. Refer to the function documentation in IEx
with h Ash.create for more details on these options.

14.4.2. Using Tenant in Ash.Query and Ash.Changeset
If we are using Ash.read that uses the query immediately after creating it, then
tenant can also be set in the Ash.read function call itself rather than setting it
using set_tenant/2. However, if we are creating query which is being passed on
to other functions for composition and if those other functions need to know the
tenant, then set_tenant/2 is the right approach to do.

For Ash.Query.for_read/3:
# Instead of this which gets all projects
Ash.Query.for_read(Tuesday.Projects.Project, :read)
|> Ash.read(authorize?: false)
# Use this to get projects for the given tenant
Ash.Query.for_read(Tuesday.Projects.Project, :read)
|> Ash.Query.set_tenant(organization.id)
|> Ash.read(authorize?: false)

Similar to Ash.Query, the tenant can be either set in the Changeset using
Ash.Changeset.set_tenant or directly when calling Ash.create depending on
how the changeset is being used.
Whether the tenant is set directly in Ash.funcs or set using
set_tenant function in Ash.Query/Ash.Changeset, the result is
always the same. Under the hood, Ash.funcs which take the tenant
value, is internally setting the tenant in Ash.Query or Ash.Changeset
and is only a convenient shortcut essentially executing the

230

set_tenant.

For Ash.Changeset.for_create/4:
params = %{name: "Project Name", end_date: ~D[2025-05-09]}
# Instead of this which creates for project for any organization
Ash.Changeset.for_create(Tuesday.Projects.Project, :create_project,
params)
|> Ash.create(authorize?: false)
# Use this to create project for the specified tenant
Ash.Changeset.for_create(Tuesday.Projects.Project, :create_project,
params)
|> Ash.Changeset.set_tenant(organization.id)
|> Ash.create(authorize?: false)

14.4.3. Using Tenant in Domain Interface Functions
Domain interface functions as shown below have different number of arguments
based on how the interface is configured. In every case, the last argument of an
interface function is always a keyword list which accepts tenant configuration as
shown above.
For domain code interface:
# Instead of this which gets all projects
Tuesday.Projects.list_projects!(authorize?: false)
# Use this to get projects for the given tenant
Tuesday.Projects.list_projects!(tenant: organization.id, authorize?:
false)

14.5. Summary
The chapter explored Ash’s Multitenancy feature, which ensures data isolation for
tenants in SaaS applications, using the Tuesday application’s Organization,
Project, Task, and ProjectMember resources as examples. Below are the key

231

concepts covered.

14.5.1. Key Concepts
• Tenant Definition: A tenant, like an organization in Tuesday, groups data with
a database boundary like organization_id to prevent data leaks.
• Enabling Multitenancy: Resources use a multitenancy block with strategy
:attribute to filter queries and enforce tenant isolation, or :context for
schema-based isolation.
• Indirectly Related Resources: Resources like Task, indirectly linked to
Organization,

should

include

organization_id

and

multitenancy

configuration for secure, efficient queries without joins.
• Benefits and Trade-offs: Adding organization_id to tenant-aware resources
boosts security and query speed, with Ash minimizing ID mismatch risks,
outweighing minor redundancy concerns.

232

Chapter 15. Ash Generator
The Ash Generator is a utility module in the Ash framework that allows us to define
a Generator module within our application. This module simplifies inserting data
into our database for testing purposes. When we build applications with Ash,
thorough testing is essential to ensure everything functions as expected. Generating
realistic test data can be challenging, but Ash.Generator streamlines this process
by providing us with powerful tools to create seed data and action inputs.

15.1. How to create Generator module?
A Generator in our project is a regular Elixir module that use Ash.Generator. In
the case of Tuesday, we have a fully functional generator module defined at
test/support/generator.ex. There is no hard and fast rule to write it at this
location but it’s more of a convention to write test support files here.

test/support/generator.ex
defmodule Tuesday.Generator do
use Ash.Generator
end

This module defines several functions which we use in our test files for setting up
test data. For a function to act as a generator, it should return a stream data by
calling seed_generator/2 function as shown below:
def user(opts \\ []) do
user_template = %User{
email: email()
}
seed_generator(user_template, overrides: opts)
end

The user function defined in Tuesday.Generator is a generator function because
it returns a value from seed_generator/2. The Tuesday.Generator module can

233

also include other utility functions, such as a function to select a random date, that
do not return stream data or use seed_generator/2, and these are perfectly
acceptable.
In this chapter, we will explore the various concepts of Ash.Generator by
examining practical examples from the Tuesday.Generator module. This module
generates test data for users, organizations, projects, tasks, and comments. If you
are starting with this chapter directly, we invite you to first refer to the README
chapter for a quick overview of what the Tuesday app does and the various
domains and resources it includes. This knowledge is essential to understand how
we are designing the generator module. We will highlight key features that make
Ash.Generator a game-changer for developers.

15.2. Can this Generator be used in Dev environment?
By default, all modules defined in the test folder of the project is available only in
the test environment and they are not available in the dev environment. For
example, if we open up iex -S mix and try to use the generator module, it will
result in unavailable module error. This is due to how Phoenix configures its
project in the default mix.exs file. For Tuesday, we want this generator module to
be available in our dev environment as well so that it’s easy to play around with the
project’s functionality quickly. So we have already configured the project to make
use of generator in dev environment. You do not have to do anything in Tuesday,
but if you want the same in your own Ash project, open your mix.exs file and
identify these two lines:

mix.exs
defp elixirc_paths(:test), do: ["lib", "test/support"]
defp elixirc_paths(_), do: ["lib"]

and modify it as below:

mix.exs
defp elixirc_paths(:test), do: ["lib", "test/support"]
defp elixirc_paths(:dev), do: ["lib", "test/support"]
defp elixirc_paths(_), do: ["lib"]

234

This modification allows Elixir modules defined in test/support to be available in
our dev environment.

15.3. Direct Data Seeding with seed_generator/2
One of the core strengths of Ash.Generator is its ability to create records directly in
the database, bypassing action logic or the policy enforcement defined in each Ash
resource. This is perfect for setting up test data quickly. The seed_generator/2
function is the go-to tool for this.
In Tuesday.Generator, we have several example of seed_generator/2. Here
below we are picking up user/1 function as an example to study. This helper
function helps us in inserting a new user in the database and is defined as shown
below:
def user(opts \\ []) do
user_template = %User{
email: email()
}
seed_generator(user_template, overrides: opts)
end

In the user/1 function, a %User{} struct is used to define a template for the user
with an email field. We have another helper function email/0 that takes care of
generating unique email IDs for our testing. We will cover how to create these
helper functions later in this chapter. For now, you can just assume that email/0
creates unique email IDs without going into the details.
The seed_generator/2 function takes this user template and produces a stream
that is used to create User records directly in the database. It’s important to note
that seed_generator/2 doesn’t insert the data into the db and it just creates a
stream. We need to call Ash.Generator.generate/1 passing in our stream to
create a record in our db.
So the above generator would be called in our test files like
# Assuming we have imported our Tuesday.Generator module
user = generate(user())

235

# otherwise a more verbose way of calling would be
user = Ash.Generator.generate(Tuesday.Generator.user())

Notice that opts argument of user/1 is passed as overrides: opts option to
seed_generator/2. This lets us tweak specific fields in our template. For example,
assuming that we want one user with the default random email and another user
with an email that we hard code, we could call the generator as below:
# generate user with random email as defined in generator
user = generate(user())
# generate user with a specific email
# overriding the option defined in generator
user_opts = [email: "user@example.com"]
user = generate(user(user_opts))
# or directly inline when calling user generator
user =

generate(user(email: "devy@example.com"))

Every generator in Tuesday.Generator like the organization/1, project/1,
task/1, comment/1 and more uses seed_generator/2 to create seed data. Check out
organization/1 or task/1 to see how it handles different resources with varied
fields.

15.4. Unique Value Generation with sequence
When testing, we often need unique values, like unique organization names, to
differentiate multiple test data or it could be even our domain constraint.
Ash.Generator provides the sequence/2 function to generate values that are
unique within a test.
In Tuesday.Generator, we have multiple usage of sequence/2. For our study, we
will take up the usage of sequence/2 inside organization/1 helper which is
defined as shown below:
def organization(opts \\ []) do
organization_template = %Organization{

236

name: sequence(:organization_name, &"Organization #{&1}"),
plan_type: StreamData.member_of([:free, :premium, :enterprise]),
can_member_create_project: StreamData.boolean()
}
end

Just focus on the highlighted line without worrying about the other lines which are
explained in the subsequent questions. This organization/1 function helps in
inserting organizaton data ensuring no two organizations have the same name
during a test.
The above code is a shorthand idiomatic form of passing anonymous functions. For
beginners in Elixir or someone not preferring this shorthand form, the long form
representation of the same code is
name: sequence(:organization_name, fn(counter) -> "Organization
#{counter}" end)

The first argument to sequence/2 is the name of the sequence, which can be any
atom. In Tuesday.Generator, we use sequence multiple times for different
resources, such as Task and Project, in addition to its use in Organization, as
shown above. Assigning different names to each sequence ensures that the
sequence number for Organization does not interfere with the sequence number
for Task, with each sequence counter starting from 0.
The second argument to sequence/2 is an anonymous function which takes the
current counter value and returns the string we want to use as the organization
name. We interpolate the counter value in a static string to make it unique
everytime the sequence is used.
Try inserting multiple organization as shown below in your iex shell and you will
find the organization name is unique every time as the counter by 1 automatically
for every call.
iex>

Tuesday.Generator.organization() |> Ash.Generator.generate()

#Tuesday.Workspace.Organization<
name: "Organization 0"...

237

iex>

Tuesday.Generator.organization() |> Ash.Generator.generate()

#Tuesday.Workspace.Organization<
name: "Organization 1"...

Take a look at the various references to the use of sequence/2 in other helper
functions such as task/1 or project/1 for more examples.

15.5. One-Time Value Generation with once
Sometimes, we want to generate a value once and reuse it across multiple records
in a test. This is common for shared dependencies, like a single organization ID
used by multiple projects. The once/2 function ensures a value is created only once
per test.
Again we have multiple instances of once/2 usage in Tuesday.Generator and for
our study, we will focus on the project/1 function which is reproduced below:

test/support/generator.ex
def project(opts \\ []) do
organization_id =
opts[:organization_id] ||
once(:default_organization_id, fn ->
generate(organization()).id
end)
start_date = random_date()
end_date = Date.add(start_date, Enum.random(31..45))
project_template = %Project{
name: sequence(:project_name, &"Project #{&1}"),
description: StreamData.string(:alphanumeric, min_length: 100,
max_length: 200),
start_date: start_date,
end_date: end_date,
status: StreamData.member_of([:archived, :active, :completed]),
organization_id: organization_id
}
seed_generator(project_template, overrides: opts)

238

end

Focus on the highlighted lines ignoring the rest.
When inserting a project record, we need a valid organization_id which is only
possible if we insert an organization before hand. We want to be able to insert a
project without requiring the user to provide the organization_id. In case, if the
user provides us the organization_id while inserting a project record we want
to use the provided one. However if the user doesn’t provide organization_id, we
want to create an organization and use the newly created organization_id. For
subsequent request from the user to create a project without organization_id,
we want to reuse the created organization from the previous call.
Try inserting multiple project as shown below in your iex shell and you will find
the project name is unique every time similar to how we saw in the organization
helper.
iex>

Tuesday.Generator.project() |> Ash.Generator.generate()

#Tuesday.Projects.Project<
name: "Project 0",
organization_id: "601b0523-ffcc-441c-bbd1-c8e242ec9559"...
iex>

Tuesday.Generator.project() |> Ash.Generator.generate()

#Tuesday.Projects.Project<
name: "Project 1",
organization_id: "601b0523-ffcc-441c-bbd1-c8e242ec9559"...

However, instead of creating a new organization for every project, because we used
once helper for generating organization_id, our organization was created only
once and our subsequent calls reuse the result from previous call resulting in the
same ID as seen above. This also ensure related records (e.g., all projects) reference
the same organization, making tests more realistic.
For more examples of reusing IDs with once, see organization_member/1 (for
organization_id

and

user_id),

task_assignee/1

(for

task_id

and

member_id), and comment/1 (for task_id and member_id) .

239

15.6. Randomized Data with StreamData
To make test data realistic, we often need randomized values, like statuses or
descriptions. Ash.Generator integrates with the StreamData library to generate
random data that’s perfect for property-based testing.
Example: Randomizing Task Attributes In the task/1 function, fields like
is_complete, description, and priority use StreamData to create varied,
random values.

test/support/generator.ex
is_complete: StreamData.member_of([:true, :false]),
description: StreamData.string(:alphanumeric, min_length: 100,
max_length: 200),
priority: Enum.random(1..5)

StreamData.member_of/1 picks random values from a list (e.g., :true, :false), while
StreamData.string/2 generates random strings within constraints. There is no
specific constraint to use only StreamData functions in the generator. We can mix
regular functions like Enum.random/1 as shown above for priority field.
Try inserting multiple task as shown below in your iex shell and you will find the
attribute values for the created tasks are unique for is_complete, description
and priority.
iex>

Tuesday.Generator.task() |> Ash.Generator.generate()

#Tuesday.Projects.Task<
title: "Task 0",
description: "oJxsqiBbIfRwqN7dUJ1CfGOMBlKrRPl...",
is_complete: :true,
priority: 2
iex>

Tuesday.Generator.task() |> Ash.Generator.generate()

#Tuesday.Projects.Task<
title: "Task 1",
description: "G8abOlaKbCmzaxf08NDJdCnsl8OzrrcRw...",
is_complete: :false,
priority: 3,

240

15.7. Composing Generators for Complex Data
Real-world applications often require related data, like an organization with a
member. We can create custom functions that assemble multiple generator
functions that we have learned to create interconnected records.
For

example

to

create

Organizations

create_organization_with_member/1.

The

with

Members,

look

at

function

generates

both

an

organization and an associated member, tying them together.

test/support/generator.ex
def create_organization_with_member(opts \\ []) do
member_opts = Keyword.get(opts, :member, [])
member_user_id =
member_opts[:user_id] ||
once(:default_member_user_id, fn ->
generate(user()).id
end)
member_opts = Keyword.merge(member_opts, role: "owner", user_id:
member_user_id)
%{
organization: generate(organization(opts)),
organization_member: generate(organization_member(member_opts))
}
end

The difference in this function is that instead of returning seed_generator/2
response like we did in previously explained function, we return here a custom
map. We also call the generate/1 function to trigger creation of organization
and organization_member from inside this function.

15.8. Custom Utility Functions
Lastly let’s look at the utility function we have defined for generating random
usernames and emails.

test/support/generator.ex
defp username, do: StreamData.string(:alphanumeric, min_length: 5,

241

max_length: 10)
defp email,
do: StreamData.bind(username(), fn name -> StreamData.constant("#{
name}@example.com") end)

The username/0 generates a randomg string with a constraint on the length to be
used as usernames.
The email/0 helper creates random email addresses by combining the username
stream generator with a fixed domain as the constant value.

15.9. Writing more enjoyable tests
When we write tests, we often spend most of our time creating setup data, while the
actual action typically involves a single line of code followed by one or more assert
statements. By designing our generator thoughtfully, we can streamline the
creation of setup data, simplifying our tests and making them more enjoyable to
write. We will use the same principle we used in the section "Composing
Generators for Complex Data".

Dev Story
For Tuesday, we need an actor for all tests that check the
authorization policy. The actor is always the OrganizationMember
record. However, we cannot create this record without first
creating a User record and an Organization record. The
OrganizationMember record is also central to Tuesday because
every other record—whether a project, task, comment, or even
audit log—connects to it directly or indirectly. Given the pivotal role
of the OrganizationMember record, we must optimize its creation
in our test helpers to enhance efficiency.
Let’s look at the example of create_org_member test helper in Tuesday to
understand how we can define our custom functions so as to further streamline our
test writing process by using what we have learned so far about Ash Generator.

242

We have 5 different ways of using this helper function. In all the variations, we
want the function to always returns a keyword list in the following structure:
[
user: user,
organization: organization,
org_member: org_member
]

The variations are
1. Create new records for all three resources.
2. Reuse an existing user to test user-specific behavior.
3. Reuse an existing organization to test org-specific behavior.
4. Reuse user and organization to focus on the relationship record org_member.
5. Add role customization to org_member for relationship testing with different
roles.

test/support/generator.ex
@valid_org_member_opts [:user, :organization, :role, :status,
:username]
def create_org_member(opts \\ []) do
case validate_options(opts, @valid_org_member_opts) do
{:ok, opts} ->
user =
opts[:user] ||
once(:default_user, fn ->
generate(user())
end)
organization =
opts[:organization] ||
once(:default_organization, fn ->
generate(organization())
end)
user_org_opts = [

243

user_id: user.id,
organization_id: organization.id
]
member_opts = Keyword.merge(user_org_opts, opts)
%{
user: user,
organization: organization,
org_member: generate(organization_member(member_opts))
}
error -> error
end
def validate_options(opts , valid_keys) when is_list(opts) and
is_list(valid_keys) do
keys = Keyword.keys(opts)
cond do
Enum.all?(keys, &(&1 in valid_keys)) -> {:ok, opts}
true -> {:error, {:invalid_keys, keys -- valid_keys}}
end
end

15.10. How to use our test helper?
The following examples demonstrate various ways to use the helper function
create_org_member/1 to create User, Organization, and OrganizationMember
resources for testing purposes.
Example 1: Create All Three Resources
Invoke create_org_member without any arguments, to create all three resources:
a user, organization, and org_member and return them in a map for subsequent
use in tests.
%{user: user, organization: organization, org_member: org_member} =
create_org_member()

Example 2: Customize org_member with Additional Options

244

Invoke create_org_member with a keyword list of attribute values for
org_member to create three resources but customizes the org_member with specific
attributes like role, status, and username.
%{user: user, organization: organization, org_member: org_member} =
create_org_member(role: "admin", status: "active", username: "devy")

Example 3: Pattern Match on Specific Resources
This code demonstrates pattern matching to extract only the needed resources (e.g.,
user and org_member, organization and org_member, or just org_member) from
the result of create_org_member/1.
%{user: user, org_member: org_member} = create_org_member()
%{organization: organization, org_member: org_member} =
create_org_member()
%{org_member: org_member} = create_org_member()

Example 4: Reuse an Existing User
Invoke create_org_member with an existing user (generated separately) to create
an organization and org_member record, returning all three of them in a map.
Since we already have user record, we only match the newly created ones for
subsequent use in the tests.
user = generate(user())
%{organization: organization, org_member: org_member} =
create_org_member(user: user)

Example 5: Reuse an Existing Organization
Invoke create_org_member with an existing organization (generated separately)
to create an user and org_member record, returning all three of them in a map.
Since we already have organization record, we only match the newly created
ones for subsequent use in the tests.
organization = generate(organization())

245

%{user: user, org_member: org_member} = create_org_member(organization:
organization)

Example 6: Reuse Both Existing User and Organization
This code reuses both an existing user and organization (generated separately)
to create an org_member, returning all three in a map.
user = generate(user())
organization = generate(organization())
%{org_member: org_member} = create_org_member(user: user, organization:
organization)

Example 7: Handling Invalid Options
This code demonstrates an incorrect usage where invalid options (for example,
user_id) are passed, causing the pattern match to fail due to validation checks on
permitted keys.
user = generate(user())
organization = generate(organization())
%{org_member: org_member} = create_org_member(user_id: user.id)
** (MatchError) no match of right hand side value: {:error,
{:invalid_keys, [:user_id]}}

With a simple composition of different generator functions, we now have a good
test helper that can help us easily generate the test data, including handling of
incorrect usage of the helper function.

15.11. Summary
The chapter explored the Ash.Generator module, a utility for generating test data
in

Ash

applications,

using

the

Tuesday

application’s

generator

(Tuesday.Generator) as an example. Below are the key concepts covered.

15.11.1. Key Concepts
• Generator Overview: Tuesday.Generator, creates test data for resources,

246

enabled in dev environment via updates in mix.exs.
• Direct Data Seeding: seed_generator/2 streams data for direct database
insertion,

bypassing

logic

and

policies;

generate/1

inserts

it

with

customizable overrides.
• Unique Value Generation: sequence/2 creates unique test values, like
organization names, using distinct counters per sequence to avoid resource
conflicts.
• One-Time Value Generation: once/2 generates a single value per test, reused
across records, ideal for consistent dependencies like shared organization IDs.
• Composing

Generators:

Custom

functions

like

create_org_member/1

combine generators for linked data, returning structured maps for tests.

247

Chapter 16. Testing Ash Code
Before we start with how to test with Ash, let’s quickly go through why we want to
write test and how to write tests in general. This will give us a solid recap of the
fundamentals even if you are already familiar with testing to help us write test in
Ash.

16.1. Why do we write tests?
Amongst so many reasons, we personally feel there are three primary reasons why
a developer writes test. These are:
1. Ensure expected behaviour
2. Think and handle edge case scenarios
3. Ensure confidence in future changes in code

16.1.1. Ensure expected behaviour
We write software to meet specific business needs. Our clients provide a list of
requirements, which they share with us through documentation. We must ensure
all these requirements are met while writing the software. Writing tests reassures
us that all these requirements are handled, as we can review the tests we’ve
written. In this sense, our catalog of tests serves as a summary of the client
requirements implemented in our software.

16.1.2. Think and handle edge case scenarios
Writing tests also helps us identify edge case scenarios that may not be well
captured in our client’s requirements. For example, in Tuesday, writing tests for
removing a project member prompted us to consider how to handle tasks assigned
to the member being removed from the project. We identified several possible
approaches:
1. Unassign all tasks the member was assigned to and then remove the member.

248

2. Leave the tasks untouched but remove the member from the project while
retaining the member in the organization.
3. Keep the member in the project while changing their status to disabled. …
There is no right answer to this and it’s normally upto the client to decide what is
the intended behaviour in this scenario. However, many times, we have noticed
that requirements from the client are not fully covering all of the edge cases and
writing tests is an opportunity window to think about these.

16.1.3. Ensure confidence in future changes in code
As our software grows larger and the original team members who wrote it are no
longer available, we often hesitate to change any line of code due to the fear of
breaking something significant while making small modifications. This lack of
confidence in making changes stems from the impossibility of retaining the
software’s entire requirements in our memory over its lifetime. Any change we
make could potentially break code written to fulfill other requirements. By writing
tests, we ensure that future code changes do not introduce new bugs without our
knowledge. Since our test suite notifies us of any failed tests triggered by new code
changes, we can write and fix code with confidence, knowing when we’ve
introduced errors.

16.2. How to write tests in general?
We had a quick summary of why we need to write tests and now let’s look at how to
write tests. When we write tests, we want to write it in a way that is
1. Clarifying test intent
2. Staying pragmatic
3. Keep concerns separate

16.2.1. Clarifying test intent
Our tests should be clear for both the current writer and also to the future reader. It
should be optimized for reading and not for writing. A test is written once,
probably modified a couple of times but is read many many times by the current

249

author, other team members and future collaborators.
Every line of code or comments that we write in a test carries a maintainability
burden. If we write a line of code and accompany it with a line of comment, we
need to ensure that the comment always is changed when the code is changed. So
writing code that is cleaner and clarying the intent without additional comment is
always preferred to writing test with a lots of in-line comments. Most of the time,
this can be achieved by using meaningful variable names and data instead of some
random names and thoughtless test data.
Let’s take a look at the following test:
test "check project creation permission" do
org1 = Organization.create!(%{name: "Organization 1", plan_type:
"free"})
u1 = Member.create!(%{role: :owner, orgainization_id: org1.id})
user2 = User.create!(%{role: :standard, organization_id: org1.id})
new_project = Projects.create!(
%{
title: "Launch Marketing Campaign",
start_date: Date.utc_today(),
end_date: Date.add(Date.utc_today, 10),
description: "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum.",
organization_id: org1.id
}, actor: u1)
assert new_project.title == "Launch Marketing Campaign"
assert_raise Ash.Error.Forbidden, fn ->
Project.create!(%{title: "Update Website"}, )
end
end

In the above example, there are a number of issues relating to the first principle of
how to write a test with clarifying intent. In a test, intent is clarified in
1. the test name
2. test setup data

250

3. action and assertion
Test name
Our test name, "check project creation permission," is not clear about which
permission is being checked. A better description would be "owner can create
project," "standard user cannot create project," or "logged-in user can create
project," depending on the business requirement. If this clearer intent requires us
to define multiple tests, we should embrace this and create multiple tests rather
than attempting to create one overly complex test with multiple checks or intents.
In fact, this is exactly what we do here: we will split the test into two.
test "owners can create projects" do ... end
test "non-owners cannot create projects" do ... end

Test Setup
org1 = Organization.create!(%{name: "Organization 1", plan_type:
"free"})
u1 = Member.create!(%{role: :owner, orgainization_id: org1.id})
user2 = User.create!(%{role: :standard, organization_id: org1.id})

The setup data contains too many lines of code, which distracts readers trying to
understand the code. Additionally, it uses random variable names like org1, u1,
and user2. The fewer variables in the setup, the easier it is to read and understand.
The setup also tries to create data for multiple scenarios, such as an owner
attempting to create a project and a non-owner attempting to create a project. As
we split the tests into two for clearer intent, we will also split the test setup and
make the code more concise and organized.
test "owners can create projects" do
owner = generate(organization_member(role: :owner))
end
test "standard members cannot create projects" do
non_owner = generate(organization_member(role: :standard))
end

251

With the modified setup data, we completely remove the creation of the
organization from the setup. Our helper for creating an organization_member
should create the organization in the background for us, hiding those details, as
they are not necessary to understand the current test. What is essential for
understanding the current test is that we create an organization member with an
owner role and a standard role in these two tests. Setup data created using
Ash.Generator makes this intent very clear.
Action and Assertion
new_project = Projects.create!(
%{
title: "Launch Marketing Campaign",
start_date: Date.utc_today(),
end_date: Date.add(Date.utc_today, 10),
description: "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum.",
organization_id: org1.id
}, actor: u1)
assert new_project.title == "Launch Marketing Campaign"

Then finally, our action adds too much noise with all the attributes requires to
create a project and the assertion is meaningless as it checks if the new_project title
is same as the one we created. Though this can be possible only when the project is
successfully created, which is the intent for our testing, it doesn’t directly reveal the
same. A better way to do this in our test would be something like
owner = generate(organization_member(role: :owner))
project_params = project_params(organization_id: owner.organization_id)
assert Projects.can_create_project?(owner, project_params)

We use Ash’s can_? functions generated when we defined the code interface to
check if the actor in question can actually create the resource with the given
params.
Because we have removed all the clutter from our action and assertion, every single
visible piece of code is speaking the intent very clearly and makes it very obvious

252

for the reader on what that test is supposed to do.
1. We are creating a project_params where the organization_id is same as the
owner’s organization_id.
2. We are checking if someone can create a project through our assertion by
passing in the project_params and that someone we are checking is passed to
the assertion as the actor.
This finally leads us to the following code, which in our opinion is clearly calling
out the intent and easy to understand
test "owners can create projects" do
owner = generate(organization_member(role: :owner))
project_params = project_params(organization_id: owner
.organization_id)
assert Projects.can_create_project?(owner, project_params)
end
test "standard members cannot create projects" do
standard_user = generate(organization_member(role: :standard))
project_params = project_params(organization_id: standard_user
.organization_id)
assert Projects.can_create_project?(owner, project_params)
end

16.2.2. Staying pragmatic
By this, we mean that we evaluate the cost versus benefit of writing tests and aim to
keep our costs low. We do not want to write tests merely for the sake of
completeness but to closely align with our "three whys" discussed earlier. Even
when aligning with those three whys, we want to ensure that we do not write tests
that take time to create and provide little utility value for us as developers.
For example, assuming that we have a Task resource with status field as an Enum
field, the following test is of low value in our opinion.

253

test "task status enum is case-insensitive" do
task1 = Task.create!(%{title: "Plan Meeting", status: :pending})
task2 = Task.create!(%{title: "Review Notes", status: "PENDING"})
assert task1.status == :pending
assert task2.status == :pending
end

We would not recommend writing such tests because these are tests that Ash itself
handles. Writing such tests in our application adds little value to our requirements.
However, even if we use Ash to make a title field in a Task resource required, a
test to check if the title is required remains valid.
test "task creation fails without a title" do
changeset =
Ash.Changeset.for_create(Task, :create_task, %{
title: nil
})
assert_has_error(changeset, fn error ->
match?(%{field: :title, message: "is required"}, error)
end)
end

This is because it’s checking how our business requires the software to function. If
"tasks must have titles" is a domain rule (example: for clarity in UI, reports, or
workflows), capturing it in a test verifies that the system meets this need, per our 1

st

principle in "3 whys". This also prevents an accidental switch to allow_nil?:
true later (example: during code refactoring). Without the test, a developer might
miss the implication, breaking the app’s intent.

16.2.3. Keep concerns separate
Let’s say in our app we have 100 different tests that validated various input rules
for creating different tasks, projects. Each test was written assuming a specific actor
like the standard_user role. For eg. something like below:

254

test "valid input creates a new task" do
standard_user = create_member(role: "standard_user")
task_params = %{
title: "Some Task",
description: "some description",
priority: 3,
start_date: ~D[2025-04-10],
due_date: ~D[2025-05-11]
}
assert {:ok, _task} = Tuesday.Projects.create_task(task_params, actor:
standard_user)
end

The intention of the developer writing this test is to check only the valid inputs lead
to a task creation. However, it’s tied to checking with the actor because the
developer has chosen a wrong utility function to test the input validity, which in
this case is create_task function. This function requires an actor as per the
authorization rules set in the application.
What is the issue with this? It still works, right? Consider a scenario where our
business rules change to state that a standard_user can no longer create tasks, but
only a project_member role can. To implement this new requirement, we would
add a new constraint to the code to enforce this policy and remove any old policy
that is no longer relevant. Ideally, we should only need to fix one or two failing tests
that previously checked whether a standard_user could create a task.
However, if we have written tests like the example above, we might see several
hundred tests fail for no apparent business reason related to those test scenarios.
These tests fail not because input validations were broken, but because they were
tied to the standard_user role. These tests were not intended to check
authorization; they focused on input rules, such as whether a title was required
or a due_date was valid. The policy change should have only affected tests
explicitly verifying what a standard_user can do, not those indifferent to the
actor’s identity. This cascade of failures demonstrated how coupling the actor to
unrelated concerns made the test suite fragile and difficult to maintain.
In summary, a test should verify one’s behavior. Example - "does this input

255

validate?" and not conflate it with "can this user perform the action?" When we do
conflate multiple concerns like these unintentionally, it leads into a maintenance
headache and we wouldn’t be motivated to do write tests.

16.3. Tuesday Tests
Tuesday project that comes with this book contains an exhaustive list of tests for
various use cases.
We have followed a few practices as we wrote these tests and we feel it would be
helpful to share our rationale behind these.
For all the actions we have defined in the Ash Resouces, we have a correspending
test file.
For example, for Task resource defined in /lib/tuesday/projects/task.ex file,
we have a corresponding test module TaskTest defined in
/test/tuesday/projects/task_test.exs
In these test files for resources, we test the data validation for the actions defined in
the respective resource files. For example, if we have an action to create a task and
have several validation on the input data, we restrain using inserting/updating
records for all these possible validations. We only create changesets for these
different data inputs and verify if the changeset is valid or not. This ensures that we
avoid the problem of unrelated tests failing due policy issues as discussed in detail
in the previous section.
Imagine a test case for creating a task as shown below:
actor = Tuesday.Workspace.create_member(%{role: "standard"...})
project = Tuesday.Projects.create_project(project_params, actor: actor)
assert {:ok, _} = Tuesday.Projects.create_task(task_params, actor:
actor)

Instead of writing the test like above which depends on an actor, we prefer the code
snippet below:

256

changeset =
Ash.Changeset.for_create(Task, :create_task, %{
title: "Some Task",
description: "some description",
priority: 3,
start_date: ~D[2025-04-10],
due_date: ~D[2025-05-11],
project_id: project.id
})
assert changeset.valid?
assert changeset.attributes.title == "Some Task"

We do not include any setup data in our test because our intent is solely to verify
that a task record will be created when we provide all valid inputs. A record will be
created if the changeset is valid. Therefore, if we confirm that our input results in a
valid changeset or that the changeset contains the correct attributes we set, we do
not need to test the code further. We avoid inserting or updating records as much
as possible and focus on testing the validation of changesets for various conditions.
In cases where asserting on a changeset without applying it to the
database does not provide sufficient confidence, we can proceed
with the actual mutation by passing authorize?: false to the
function performing the change. This ensures that the policy check
is completely bypassed, validating only the insertion. For example,
we

can

use

Ash.create(changeset,

%{},

authorize?:

false) in tests, as we have done throughout the book for running
code in the IEx shell.
This not only simpifies the test we write but also ensures that our tests don’t fail for
unexpected reasons.

16.4. Summary
The chapter explored testing strategies for Ash applications, emphasizing best
practices and practical approaches, using the Tuesday application’s test suite as an
example. Below are the key concepts covered.

257

16.4.1. Key Concepts
• Why Write Tests:
◦ Expected Behavior: Tests verify that the application meets business
requirements, serving as a catalog of implemented functionality.
◦ Edge Cases: Tests help identify and handle edge scenarios not explicitly
covered in requirements (e.g., handling tasks when removing a project
member).
◦ Future Confidence: Tests provide assurance for future code changes,
preventing regressions by catching unintended breaks.
• How to Write Tests:
◦ Clarify Intent: Tests should be readable, using meaningful variable names
and focused setups to clearly convey purpose.
◦ Stay Pragmatic: Focus on high-value tests aligned with business needs,
avoiding low-value tests (e.g., testing Ash’s internal enum handling) while
validating domain rules (e.g., required fields like task titles).
◦ Separate Concerns: Isolate test concerns (e.g., input validation vs.
authorization) to prevent unrelated failures (e.g., policy changes breaking
input validation tests). Use changesets for validation tests to avoid policy
dependencies.

258

Conclusion
Phew! We’ve covered a lot in this book. Now is a great time to review the entire
Tuesday project and ensure you understand all the Ash code. Our extensive test
suite is worth exploring and may be interesting to read. You could challenge
yourself to build JSON or GraphQL APIs on top of the current codebase by referring
to the documentation. You could also try using the ash_slug extension instead of the
custom slugifying code we provided.
As authors, we’re deeply grateful that you took the time to read this book. Thank
you for trusting us and letting us be part of your Ash learning journey. If you have
any questions, suggestions, or feedback, please feel free to reach out to us at:
feedback@devcarrots.com.

259

