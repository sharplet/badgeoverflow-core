## Adding support for new badges

First, take a look at the [badges directory](https://github.com/sharplet/badgeoverflow-core/tree/master/lib/badgeoverflow/core/models/badges).
In here you'll find the `Badge` base class, along with all the
subclasses that implement progress calculation for individual badges.
These subclasses are organised into subdirectories according to their
category (`questions/`, `answers/`, and so on).

You should override two methods: `#progress_title`, which should return
a string to be displayed above the badge name, and
`#progress_description`, which should fetch any data required,
calculate the progress, and return a formatted string describing the
user's progress.

You can fetch data through the `#service` attribute (which returns an
instance of `StackExchangeService`), and the user ID is available
through the `#user_id` attribute.

The name of the subclass needs to be the badge's name, in camel case,
and stripped of all non-letter characters. So "Nice Question" becomes
`NiceQuestion`, and "Strunk & White" becomes `StrunkWhite`. As long as
the class is named correctly, the Badge Overflow unearned badges job
should automatically use it to calculate the user's progress.

## Other contributions

Issues and pull requests are welcome! :)
