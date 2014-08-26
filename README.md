# PHP Role for Ansible [![Build Status](https://travis-ci.org/augustohp/ansible-role-php.svg?branch=master)](https://travis-ci.org/augustohp/ansible-role-php)

Installs and configures PHP (and also FPM if needed).

## Requirements

- Ansible 1.5 or greater

## Role variables

See [defaults/main.yml][1] for variables available to overwrite.

## Example playbook

    ---
    - hosts: all
      roles:
        - { role: augustohp.php }

## License

[MIT][2]

## Author Information

- [Augusto Pascutti][3]

[1]: https://github.com/augustohp/ansible-role-php/blob/master/defaults/main.yml
[2]: https://github.com/augustohp/ansible-role-php/blob/master/LICENSE
[3]: https://github.com/augustohp
