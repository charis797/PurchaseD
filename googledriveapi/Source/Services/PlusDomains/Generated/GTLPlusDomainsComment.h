/* Copyright (c) 2015 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  GTLPlusDomainsComment.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Google+ Domains API (plusDomains/v1)
// Description:
//   The Google+ API enables developers to build on top of the Google+ platform.
// Documentation:
//   https://developers.google.com/+/domains/
// Classes:
//   GTLPlusDomainsComment (0 custom class methods, 11 custom properties)
//   GTLPlusDomainsCommentActor (0 custom class methods, 4 custom properties)
//   GTLPlusDomainsCommentInReplyToItem (0 custom class methods, 2 custom properties)
//   GTLPlusDomainsCommentObject (0 custom class methods, 3 custom properties)
//   GTLPlusDomainsCommentPlusoners (0 custom class methods, 1 custom properties)
//   GTLPlusDomainsCommentActorImage (0 custom class methods, 1 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLPlusDomainsCommentActor;
@class GTLPlusDomainsCommentActorImage;
@class GTLPlusDomainsCommentInReplyToItem;
@class GTLPlusDomainsCommentObject;
@class GTLPlusDomainsCommentPlusoners;

// ----------------------------------------------------------------------------
//
//   GTLPlusDomainsComment
//

@interface GTLPlusDomainsComment : GTLObject

// The person who posted this comment.
@property (nonatomic, retain) GTLPlusDomainsCommentActor *actor;

// ETag of this response for caching purposes.
@property (nonatomic, copy) NSString *ETag;

// The ID of this comment.
// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (nonatomic, copy) NSString *identifier;

// The activity this comment replied to.
@property (nonatomic, retain) NSArray *inReplyTo;  // of GTLPlusDomainsCommentInReplyToItem

// Identifies this resource as a comment. Value: "plus#comment".
@property (nonatomic, copy) NSString *kind;

// The object of this comment.
@property (nonatomic, retain) GTLPlusDomainsCommentObject *object;

// People who +1'd this comment.
@property (nonatomic, retain) GTLPlusDomainsCommentPlusoners *plusoners;

// The time at which this comment was initially published. Formatted as an RFC
// 3339 timestamp.
@property (nonatomic, retain) GTLDateTime *published;

// Link to this comment resource.
@property (nonatomic, copy) NSString *selfLink;

// The time at which this comment was last updated. Formatted as an RFC 3339
// timestamp.
@property (nonatomic, retain) GTLDateTime *updated;

// This comment's verb, indicating what action was performed. Possible values
// are:
// - "post" - Publish content to the stream.
@property (nonatomic, copy) NSString *verb;

@end


// ----------------------------------------------------------------------------
//
//   GTLPlusDomainsCommentActor
//

@interface GTLPlusDomainsCommentActor : GTLObject

// The name of this actor, suitable for display.
@property (nonatomic, copy) NSString *displayName;

// The ID of the actor.
// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (nonatomic, copy) NSString *identifier;

// The image representation of this actor.
@property (nonatomic, retain) GTLPlusDomainsCommentActorImage *image;

// A link to the Person resource for this actor.
@property (nonatomic, copy) NSString *url;

@end


// ----------------------------------------------------------------------------
//
//   GTLPlusDomainsCommentInReplyToItem
//

@interface GTLPlusDomainsCommentInReplyToItem : GTLObject

// The ID of the activity.
// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (nonatomic, copy) NSString *identifier;

// The URL of the activity.
@property (nonatomic, copy) NSString *url;

@end


// ----------------------------------------------------------------------------
//
//   GTLPlusDomainsCommentObject
//

@interface GTLPlusDomainsCommentObject : GTLObject

// The HTML-formatted content, suitable for display.
@property (nonatomic, copy) NSString *content;

// The object type of this comment. Possible values are:
// - "comment" - A comment in reply to an activity.
@property (nonatomic, copy) NSString *objectType;

// The content (text) as provided by the author, stored without any HTML
// formatting. When creating or updating a comment, this value must be supplied
// as plain text in the request.
@property (nonatomic, copy) NSString *originalContent;

@end


// ----------------------------------------------------------------------------
//
//   GTLPlusDomainsCommentPlusoners
//

@interface GTLPlusDomainsCommentPlusoners : GTLObject

// Total number of people who +1'd this comment.
@property (nonatomic, retain) NSNumber *totalItems;  // unsignedIntValue

@end


// ----------------------------------------------------------------------------
//
//   GTLPlusDomainsCommentActorImage
//

@interface GTLPlusDomainsCommentActorImage : GTLObject

// The URL of the actor's profile photo. To resize the image and crop it to a
// square, append the query string ?sz=x, where x is the dimension in pixels of
// each side.
@property (nonatomic, copy) NSString *url;

@end
