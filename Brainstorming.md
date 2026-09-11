This is imported from notes I took on my phone on [[2026-09-08]], near 14:00, and modified to add context to decisions made. Mostly there is a preserved chain of ideas, but some of the initial table decisions were changed before the note was saved, so there were a few bad ideas for which the process was lost.

## Tables
- Posts
  - id, share_summary, above_fold, main_body, created_at, updated_at, published_at, view_status, view_count, url_slug, user_id, scheduled_at, parent_id, password_hash, 
- Users
  - id, password_hash, user_name, created_at, updated_at, display_name, 
- Comments
  - id, user_id, post_id, created_at, updated_at, main_body, view_count, parent_id, url_query, display_name, 
- Notifications
  - id, user_id, created_at, updated_at, view_status, 
- Pages
  - id, main_body, view_status, created_at, updated_at, published_at, share_summary, view_count, url_slug, scheduled_at, parent_id, password_hash, 
- Views
  - id, object_type, object_id, ip_address, created_at, updated_at, user_id, 
- Permissions
  - id, user_id, permission_type, object_type, object_id, created_at, updated_at, 

~~What if posts/comments were the same? Using parent_id to specify origin? Kinda like the reddit-like idea I had before? Can that scale or will it cause problems? Why should I care now?~~

~~There is a lot of overlap between posts, pages, and comments. If I did a parent-based system, it would also be useful for organizational hierarchy.~~ Pages can be automatically organized in URL scheme, menus, and tables of contents if they just have parent ID. Same with posts if a hierarchy is desired.

A URL slug will be ~~a fragment instead of an entire path? No, because then URLs can change when stated hierarchy changes, and~~ consistency is important. Slugs should be set once.

~~If we do "all content is one object type", that object should have a type field? Yea, it's necessary for style, how else would it know whether to display as part of another page or a separate page? How would it know whether to place it in a menu/ToC?~~

~~To replace my blog, I'll definitely have to in effect reserve a lot of slugs if I make this in a way that implicitly allows other blogs. I think that idea is too ambitious.. but gosh do I want to try!~~

~~Object types: post, page, blog, comment~~  
~~What does a blog need to define itself? It needs styling.~~

I need to NOT do the everything is an object route. It's not worth the theoretical advantages.

Comments have a `url_query` instead of a fragment or slug because they need to not interfere with the structure of posts and pages, and need to be sent to the server to display correctly if I end up with an automatic scoring system that can push comments to other pages. (This also means that comment pages should be in the query imo. I think the query part should be for more ephemeral things on here?)

Comments have a `user_id` and `display_name` so that anyone can post with a different name on any comment instead of just using their `display_name`, ~~and that also allows for a default anonymous account to have any name on any comment but still be clearly posted without an account.~~

Users have a `display_name` so that non-unique names can be used.

Editor interface needs a live preview, so I'll use marked.js for that I think? Should be contained in an iframe and loaded from a special URL so that broken code doesn't break the editor. (This is a terribly difficult way to do this, and not worth the benefit.)

Instead of one anonymous user, when someone comments, use a cookie to recognize which account they're using. Call it guest instead of anonymous, and point out that posts will be associated with each other. (This is separate from the UUIDs that will be used for anonymous view tracking. These should only be generated when someone actually succeeds in interacting.)

I decided to give posts and pages `parent_id` so that more interesting blog hierarchy is possible.

Somewhere I need to explain anonymous view tracking, ~~specifically that hashing is used to keep addresses private. No, this isn't good enough because it is trivial to find the hashes because there aren't that many IP addresses.~~ I think I should do it anyhow, but with regular address purging, combined with Geo IP guessing for stats stuff. This is all down the road stuff.

I'm trying to think how to efficiently handle the menu. It should be cached in a simple format - so let's say the complete HTML to just stick into the page raw. But it also needs to be generated from something, I was thinking each item should have an order field, but that's too cludgy. It shall be a JSON object, and needs another live preview type editor to verify correct changes before saving.

~~Cache whole pages as much as possible instead of fragments.~~

---

~~It should save space and caching fragments would still require too much processing?~~ But I want live view counts, which is incompatible with whole page caching.

view_status: public, unlisted, password_protected, internal, private, scheduled_public, scheduled_internal, scheduled_unlisted, scheduled_password_protected, 

~~Instead of having several scheduled types, just have the scheduled_at and view_status TOGETHER define visibility? That makes it less tedious, but easier to make a mistake.. I could use a separate field for subtype instead, but that would also suck.~~

This design can leak information about a page's existence based on server response time to a slug, as it processes whether permissions exist. I'm fine with that, but need it stated.

---

After this was written, I considered anonymous analytics gathering using cookies because that is easily blocked and anonymized by separating a user from an IP address. While very fragile, I think this is the best compromise between being easy to set up and preserving as much individual privacy as possible while still allowing me to gather useful data to have some concept of how much reach I have. I think it's biggest flaw is in how to deal with the background noise of spam and surface scanning for attacks that all servers encounter. It also may not be able to recognize bot scanning, especially by AI model training, because they have a vested interest in making that process as secret as possible. By making it based on cookies, which the framework I'm using ensures are secure enough to trust, I can at least keep a difference between noted instances and stuff that appears as a first-time visit. I can only count repeat visits as unique to make it easier to separate from the inflated noise of that background noise, but some data necessarily is lost by that. I also intend to put my server behind a reverse proxy that handles some amount of security and fuzzing for me, so it hopefully won't even be that bad.

At the same time, a discussion on that with my partner led to a complex hashing scheme that would be doable except that it would make restarting the service too difficult for what I want to be functional.

For posterity, I'll include their note here:

> Idea for a privacy-preserving basic metric tracker (MAUs, hot counter, etc.):
> 
> Maintain a private key.
> For each tracked metric (e.g. global site unique visitors for January 2027), generate a new unique secret using the private key and a double-ratcheting mechanism. Call that the metric secret.
> Salt the tracked data with the metric secret and hash that with a strong hasher.
> 
> And that’s it! You can even publish the hashes, and no PII can ever be leaked. Even shit that’s easy rainbow-tabled like IP addresses can’t be discovered because the secret isn’t known and is different for each metric

---

The various references to treating all data as the same type is an idea about how often data structures end up being slight variations on the same thing and a project which allows treating all hierarchical text data as something that can be viewed through any choice of lens instead of an assumed structure. I still want to pursue this idea, but having a functional blog is my biggest priority, and this does not serve that goal. (This hypothetical ideal allows treating a blog with comments, a forum, a Twitter-clone, and a Reddit-clone as all just different ways of viewing the same information. You can organize by various layers and presentations of the same stuff.)

The idea of permissions is to allow anyone with permission to anything to allow sub-permissions to other accounts depending on their own permission access, and permissions are associations rather than types to solve the problem of how traditionally nested hierarchical permissions systems group things in a way that isn't necessarily desirable for each permission. Permissions can apply to a Post, Page, or maybe even Comment, though that may be excessive. This has gotta be a future down-the-road idea. Right now, it is not a good idea.
