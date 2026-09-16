# Don't Write Comments

**Video:** [CodeAesthetics — Don't Write Comments](https://www.youtube.com/watch?v=Bf7vDBBOBUA)

---

It's time to get a bit controversial. I don't think you should write comments in your code — pretty much most of the time.

## Example 1: Magic numbers → named constants

Here we have some code where we expect the value to be five. Looking at this code, it's not obvious what five signals.

```python
if status == 5:
    message.markSent()
```

We could add a comment explaining what 5 is:

```python
# A status of 5 signals message sent
if status == 5:
    message.markSent()
```

But even better, we can create a constant representing the variable instead:

```python
MESSAGE_SENT = 5
if status == MESSAGE_SENT:
    message.markSent()
```

The if statement now reads like a comment — that we want status to be "message sent."

## Example 2: Complex conditions → named variables

If your code is complex enough that it warrants a comment, you should instead see if you can simplify or refactor the code to make it better instead.

Right now this condition is complex enough that we add a comment explaining it, but we can simplify this by using variables to name parts of the expression:

```python
# You can update a message IF the current user is the author of the message and the message was delivered
# less than 5 minutes ago OR if the current user is an administrator
# You can also edit the message if the message wasn't delivered yet

if (message.user.id == current_user.id and (
        message.delivered_time() is None or (datetime.now() - message.delivered_time()).seconds < 300
    )) or current_user.type == User.Administrator:

    message.update_text(text);
```

We can extract named variables:

```python
FIVE_MINUTES = 5 * 60

user_is_author = message.user.id == current_user.id
is_recent = message.delivered_time() is None or (datetime.now() - message.delivered_time()).seconds < FIVE_MINUTES
user_is_admin = current_user.type == User.Administrator

if (user_is_author and is_recent) or user_is_admin:
    message.update_text(text);
```

Now the condition reads like the comment does, so the comment is basically redundant and can be removed.

## Example 3: Extract to a function

When conditions are complex enough like this, you could also consider moving the whole condition to its own function. Now you don't need to decipher at all:

```python
def can_edit_message(current_user, message):
    FIVE_MINUTES = 5 * 60

    user_is_author = message.user.id == current_user.id
    is_recent = message.delivered_time() is None or (datetime.now() - message.delivered_time()).seconds < FIVE_MINUTES
    user_is_admin = current_user.type == User.Administrator

    return (user_is_author and is_recent) or user_is_admin

if can_edit_message(current_user, message):
    message.update_text(text);
```

## Types > Comments

Types can also make comments redundant. In C++ there's no built-in memory management. You often have a function like this where you get back a thing, but we need to make clear who will take ownership of the thing — ownership meaning the responsibility to release the memory after everyone is done with it.

```cpp
message* receive_message();
```

In older C++ you pretty much had to rely on comments to do this. If you were given ownership of an object, you'd find out by reading the comments of the function:

```cpp
// Gets a message.
// Caller takes ownership of message.
message* receive_message();
```

But C++ added a new type called `unique_ptr`. The type represents a unique reference to the object, so if you get one — congratulations, it's now your responsibility:

```cpp
std::unique_ptr<message> receive_message();
```

The type tells you explicitly that you now own it, without the need for a comment. And even better, the type makes it so you get a compiler error if you do bad things with it. A comment doesn't do that.

*(compiler error shown: copy constructor is implicitly deleted because `unique_ptr<message>` has a user-declared move constructor)*

## Optional types replace sentinel values

Likewise, if we have a function that returns an int but that int is optional, we could add a comment saying that -1 means we're not actually returning a value:

```cpp
// Get the delivered timestamp.
//
// A value of -1 is returned if the
// message has not been delivered.
int64_t delivered_timestamp();
```

But even better, we could use a type. If we return an `optional<int>` instead, it's now obvious that we might not give a value:

```cpp
std::optional<int64_t> delivered_timestamp();
```

We can't miss the comment and not realize that we might get an invalid timestamp back. The user needs to handle a missing value or they'll get a compiler error.

## Why not just add more comments?

You might wonder: why don't we just make our code high quality *and* add comments anyways? Isn't more comments just better?

That ignores the problems with comments. Comments get bugs, like code. When people make changes to code, they often don't update the comments to match. But unlike comments, we have tools to stop bugs from entering code — we have tests, compiler checks, and linting. We don't have any system like that for comments.

Maybe one day we can have some static analysis tool that uses AI to determine if the code matches the comments and flag any discrepancies — there's your startup idea.

But because of this, I don't trust the comments even when they exist. Comments can lie, but code cannot. So when trying to understand what a piece of code does, I read the code. I never read the comments.

## Documentation ≠ Comments

What I *do* read is code documentation. Code documentation describes the high-level architecture and public APIs of the system. Code documentation differs from comments — where comments describe the internals of how your code works, documentation describes how you *use* the code.

The world needs more high quality documentation. And while we could write the documentation for our code completely separated from our code, it makes sense to keep our documentation as close to the code as possible in order to try to help them stay in sync. Tools like Doxygen, PyDoc, and Javadoc generate documents directly from code files and therefore change alongside our code.

It's useful to document what a class or API represents, and any expectations for interface definitions like thread safety, possible states, or error conditions. This helps the consumers of the API know how to use it, and also helps any new implementers of the interface know how they're supposed to operate and behave.

The guidance I've given about comments still applies for documentation — if we write better APIs, our documentation will be more concise and less prone to errors. But I can see that you'll never be able to make all of the parts of the system obvious with pure code.

## When comments are OK

I do think there's a few cases where you should consider comments:

- If the code does something non-obvious for **performance reasons**, a comment can help explain why the code looks weird.
- If the code is utilizing a specific **mathematical principle or an algorithm** from a particular source, you might consider linking to the source to help future maintainers.

## Code is a spec

There's this comic called CommitStrip, and one of the comics is about a guy telling a developer that one day we won't need code in the future because you'll be able to simply write a spec and the program will just write itself. The developer sarcastically retorts that code is just a more precise way of writing a spec.

Code is a much better way to express intent than comments about code. So in general, if you feel like you need human language to describe your code, see if you could make your code more human.
