This is imported from notes I took on my phone on [[2026-09-08]], near 14:00, and modified to add context to decisions made. Mostly there is a preserved chain of ideas (through commits).

## Tables
- Posts
  - id, share_summary, above_fold, main_body, created_at, updated_at, published_at, view_status, view_count, url_slug, user_id, scheduled_at, parent_id, password_hash, 
- Users
  - id, password_hash, user_name, created_at, updated_at, display_name, is_admin, 
- Comments
  - id, user_id, post_id, created_at, updated_at, main_body, view_count, parent_id, url_query, display_name, page_id, 
- Notifications
  - id, user_id, created_at, updated_at, view_status, main_body, 
- Pages
  - id, main_body, view_status, created_at, updated_at, published_at, share_summary, view_count, url_slug, scheduled_at, parent_id, password_hash, 
- Views
  - id, object_type, object_id, ip_address, created_at, updated_at, user_id, 

## Thoughts
- Views as currently written cannot handle tracking non-objects, like individual pages of posts or the homepage. Or categories, tags..
- I don't use tags appropriately, and categories on Wordpress suck ass.. but my shared notes are better, so I do want categories.

Pages can be automatically organized in URL scheme, menus, and tables of contents if they just have parent ID. Same with posts if a hierarchy is desired.

- URL slugs should be set once, and be the entire URL where possible.
- Generated pages should follow Wordpress's style for drop-in consistency.
- I briefly had comments having a parent type/id to make less data storage to dynamically "comment anywhere", but realized that would cause queries to balloon out of control.
  - In theory, being able to comment on a user would be fun. Maybe I should use `owner_id` instead of `user_id` so that user relations are less confusing?
- Notifications exist as a concept because of commenting and replies to comments. They can also be used to send alerts to administrators or whatever.

Comments have a `url_query` instead of a fragment or slug because they need to not interfere with the structure of posts and pages, ~~and need to be sent to the server to display correctly if I end up with an automatic scoring system that can push comments to other pages.~~ (This also means that comment pages should be in the query imo. I think the query part should be for more ephemeral things on here?)

- Comments have a `user_id` and `display_name` so that anyone can post with a different name on any comment instead of just using their `display_name`.
  - [ ] Consider allowing anonymous comments (as in, you can be logged in, but it will not be saved associated to you)
- Users have a `display_name` so that non-unique names can be used.

Editor interface needs a live preview, so I'll use marked.js for that I think? Should be contained in an iframe and loaded from a special URL so that broken code doesn't break the editor. (This is a terribly difficult way to do this, and not worth the benefit.)

Instead of one anonymous user, when someone comments, use a cookie to recognize which account they're using. Call it guest instead of anonymous, and point out that posts will be associated with each other. (This is separate from the UUIDs that will be used for anonymous view tracking. These should only be generated when someone actually succeeds in interacting.)

I decided to give posts and pages `parent_id` so that more interesting blog hierarchy is possible.

Somewhere I need to explain anonymous view tracking, ~~specifically that hashing is used to keep addresses private. No, this isn't good enough because it is trivial to find the hashes because there aren't that many IP addresses.~~ I think I should do it anyhow, but with regular address purging, combined with Geo IP guessing for stats stuff. This is all down the road stuff.

I'm trying to think how to efficiently handle the menu. It should be cached in a simple format - so let's say the complete HTML to just stick into the page raw. But it also needs to be generated from something, I was thinking each item should have an order field, but that's too cludgy. It shall be a JSON object, and needs another live preview type editor to verify correct changes before saving.

- I want live view counts, which is incompatible with whole page caching.

`view_status`: public, unlisted, password_protected, internal, private, scheduled_public, scheduled_internal, scheduled_unlisted, scheduled_password_protected, 

This design can leak information about a page's existence based on server response time to a slug, as it processes whether permissions exist. I'm fine with that, but need it stated.

Tagging: Store unique words, allow manually added tags, have a blacklist for common words? Why bother if they aren't going to be displayed? Displayed tags should only be the median tags (as in, used on multiple posts, but not a huge fraction and not only on one post). I think the blacklist isn't actually necessary? It might make the median selection harder? How do I select tags when there is only one post or a handful of posts? The common words will fuck this idea up too badly too quickly if I don't blacklist?

Categories: Only one category per post. Use the ones from my archive rather than what's on Wordpress. Also allow unset categorization.

---

After this was written, I considered anonymous analytics gathering using cookies because that is easily blocked and anonymized by separating a user from an IP address. While very fragile, I think this is the best compromise between being easy to set up and preserving as much individual privacy as possible while still allowing me to gather useful data to have some concept of how much reach I have. I think it's biggest flaw is in how to deal with the background noise of spam and surface scanning for attacks that all servers encounter. It also may not be able to recognize bot scanning, especially by AI model training, because they have a vested interest in making that process as secret as possible. By making it based on cookies, which the framework I'm using ensures are secure enough to trust, I can at least keep a difference between noted instances and stuff that appears as a first-time visit. I can only count repeat visits as unique to make it easier to separate from the inflated noise of that background noise, but some data necessarily is lost by that. I also intend to put my server behind a reverse proxy that handles some amount of security and fuzzing for me, so it hopefully won't even be that bad.
- To only count repeat visits, every request has a UUID assigned only if one wasn't already, but we only store assigned UUIDs on a 2nd load?

## Alternate ideas to use elsewhere
I need to NOT do the everything is an object route. It's not worth the theoretical advantages.

The various references to treating all data as the same type is an idea about how often data structures end up being slight variations on the same thing and a project which allows treating all hierarchical text data as something that can be viewed through any choice of lens instead of an assumed structure. I still want to pursue this idea, but having a functional blog is my biggest priority, and this does not serve that goal. (This hypothetical ideal allows treating a blog with comments, a forum, a Twitter-clone, and a Reddit-clone as all just different ways of viewing the same information. You can organize by various layers and presentations of the same stuff.)

## Future ideas
- Automatic scoring system. Aka, reddit scoring. I might want to implement that on comments and posts/pages. Might be better elsewhere. Too much overhead for little benefit here.
- Community-made tags.

- Permissions
  - id, user_id, permission_type, object_type, object_id, created_at, updated_at, 

The idea of permissions is to allow anyone with permission to anything to allow sub-permissions to other accounts depending on their own permission access, and permissions are associations rather than types to solve the problem of how traditionally nested hierarchical permissions systems group things in a way that isn't necessarily desirable for each permission. Permissions can apply to a Post, Page, or maybe even Comment, though that may be excessive. This has gotta be a future down-the-road idea. Right now, it is not a good idea.
