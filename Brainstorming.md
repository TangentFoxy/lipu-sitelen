This is imported from notes I took on my phone on [[2026-09-08]], near 14:00.

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

~~What if posts/comments were the same? Using parent_id to specify origin? Kinda like the reddit-like idea I had before? Can that scale or will it cause problems? Why should I care now?~~

~~There is a lot of overlap between posts, pages, and comments. If I did a parent-based system, it would also be useful for organizational hierarchy.~~ Pages can be automatically organized in URL scheme, menus, and tables of contents if they just have parent ID. Same with posts if a hierarchy is desired.

A URL slug will be ~~a fragment instead of an entire path? No, because then URLs can change when stated hierarchy changes, and~~ consistency is important. Slugs should be set once.

~~If we do "all content is one object type", that object should have a type field? Yea, it's necessary for style, how else would it know whether to display as part of another page or a separate page? How would it know whether to place it in a menu/ToC?~~

~~To replace my blog, I'll definitely have to in effect reserve a lot of slugs if I make this in a way that implicitly allows other blogs. I think that idea is too ambitious.. but gosh do I want to try!~~

~~Object types: post, page, blog, comment~~  
~~What does a blog need to define itself? It needs styling.~~

I need to NOT do the everything is an object route. It's not worth the theoretical advantages.

Comments have a url_query instead of a fragment or slug because they need to not interfere with the structure of posts and pages, and need to be sent to the server to display correctly if I end up with an automatic scoring system that can push comments to other pages. (This also means that comment pages should be in the query imo. I think the query part should be for more ephemeral things on here?)

Comments have a user_id and display_name so that anyone can post with a different name on any comment instead of just using their display_name, ~~and that also allows for a default anonymous account to have any name on any comment but still be clearly posted without an account.~~

Users have a display_name so that non-unique names can be used.

Editor interface needs a live preview, so I'll use marked.js for that I think? Should be contained in an iframe and loaded from a special URL so that broken code doesn't break the editor.

Instead of one anonymous user, when someone comments, use a cookie to recognize which account they're using. Call it guest instead of anonymous, and point out that posts will be associated with each other.

I decided to give posts and pages parent_id so that more interesting blog hierarchy is possible.

Somewhere I need to explain anonymous view tracking, ~~specifically that hashing is used to keep addresses private. No, this isn't good enough because it is trivial to find the hashes because there aren't that many IP addresses.~~ I think I should do it anyhow, but with regular address purging, combined with Geo IP guessing for stats stuff. This is all down the road stuff.

I'm trying to think how to efficiently handle the menu. It should be cached in a simple format - so let's say the complete HTML to just stick into the page raw. But it also needs to be generated from something, I was thinking each item should have an order field, but that's too cludgy. It shall be a JSON object, and needs another live preview type editor to verify correct changes before saving.

~~Cache whole pages as much as possible instead of fragments.~~

---

~~It should save space and caching fragments would still require too much processing?~~ But I want live view counts, which is incompatible with whole page caching.

view_status: public, unlisted, password_protected, internal, private, scheduled_public, scheduled_internal, scheduled_unlisted, scheduled_password_protected, 

~~Instead of having several scheduled types, just have the scheduled_at and view_status TOGETHER define visibility? That makes it less tedious, but easier to make a mistake.. I could use a separate field for subtype instead, but that would also suck.~~

This design can leak information about a page's existence based on server response time to a slug, as it processes whether permissions exist. I'm fine with that, but need it stated.
