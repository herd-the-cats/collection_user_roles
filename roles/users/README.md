Users
=========

This is a basic role to create both system and regular users and groups, including self-named groups for users with a matching gid to the uid.

Requirements
------------

- Python passlib for generating password_hash
- Ansible 2.9+

Role Variables
--------------

- users\_groups_w_gids - _groups to create with specific gids (user self-named groups will automatically get gids to match uids)._
- users\_accounts - _user information as passed to the user module. See comments in defaults. Takes ssh keys and/or vaulted passwords. /etc/shadow values will be rehashed if the inventory_hostname changes._
- users\_set\_rootpw - _Boolean. Requires users\_rootpw to be set._
- users\_rootpw - _Vaulted variable with root password. Note: the /etc/shadow value will be rehashed if the inventory\_hostname changes._
- users\_saltpad - _A set of characters used to pad out the random but idempotent salt example given in the Ansible docs, because that example_
                   _only gives a limited number of integer characters. See below for details._

Usage/Extended Info
-------------------

Explanation of the random salt filter:  
```
password_hash('sha512', (users_saltpad[::users_saltpad | length | random(seed=inventory_hostname)] ~ 999999 | random(seed=inventory_hostname) | string)[-16:])  
                        ^                ^                                                         ^                                                   ^    ^   
                        1                2                                                         3                                                   4    5  
```
1. start salt value
2. take a slice of users_saltpad value using a random (but idempotent) stride derived from users_saltpad length
3. append previous padding with the standard random, idempotent integer value per Ansible docs
4. take only up to 16 characters (negative slice index to end) of the resulting combination, so as to not exceed max salt length
5. end salt value

License
-------

BSD

Author Information
------------------

herd-the-cats
