# PHP Role for Ansible [![Build Status](https://travis-ci.org/augustohp/ansible-role-php.svg?branch=master)](https://travis-ci.org/augustohp/ansible-role-php)

Manages PHP and FPM.

| Operating System                | PHP 5.3 | PHP 5.4 | PHP 5.5 |
|---------------------------------|---------|---------|---------|
| Debian 6 (Squeeze)              | *Yes*   | Yes     |         |
| Debian 7 (Wheezy)               |         | *Yes*   | Yes     |
| Ubuntu 12.04 (Precise Pangolin) | *Yes*   | Yes     | Yes     |
| Ubuntu 14.04 (Trusty Tahr)      |         |         | *Yes*   |

## Requirements

- Ansible 1.5 or greater

## Role variables

See [defaults/main.yml][1] for variables available to overwrite, the most usefull ones are listed below:

| Variable name | Value Type | Default Value | Description |
|---------------|------------|---------------|-------------|
| hwr_options.install_composer | boolean | yes | Installs [Composer][] globally |
| hwr_options.php_version | float | null | Install a different PHP version on the system from the one provided by the distro. |
| hwr_options.remove_unmanaged_extension_configuration | boolean | no | Remove unmanaged extension configuration files. |
| php_ini | list | Default, development values | List of `php.ini` to use on environment |
| php_ini_files | list | `[]` | List of `php.ini` files to apply changes to. (CLI and FPM not needed to appear in this list) |
| php_packages | list | Platform dependent | List of packages to be installed, see `vars/Debian.yml` for an example. |
| php_pecl_packages | list | `[]` | List of [pecl][] packages to install. |
| php_packages_extra | list | `[]` | List of OS packages to install (Utility configuration). |
| hwr_options.enable_fpm | boolean | yes | Enable creation and installation of PHP-FPM, as well as creation of FPM pools defined in another variable. |
| hwr_fpm_pools | list | Pool with DocRoot to `/var/www/default` | List of FPM pools to be created  and enabled |
| hwr_php_fpm_default_chdir | string | `/var/www/default` | Default document root for the default PHP FPM pool |
| php_extensions_config | dict | empty | Set custom config for php modules, overrides all other module configuration. |

### PECL packages

You can install/compile a list of [PECL][] packages using `php_pecl_packages` variables:

    php_pecl_packages:
        - timezonedb

You still need to manage extension loading and configuration through `php.ini`.
Be aware that some [PECL][] packages depend on other libraries to be compiles, installation of
these libraries should be handled by you using `php_packages_extra` configuration list.

### Composer

Composer installation is enabled by default, making `composer` as command available to you.
Packages can also be installed using `hwr_composer_packages` variable, like:

    hwr_composer_packages:
        - "phpunit/phpunit:@stable"
        - "behat/behat:dev-master"

Although the packages are installed, you need to manage the `PATH` variable of your environment
in order to have these commands available, adding `$COMPOSER_HOME/vendor/bin` directory to it.

A cron job is installed in order to daily update composer also.

### Debian configuration

You can set up a different group of packages to be installed, as well as add
different repositories to use as source for [Debian][]. The following variables
can be used:

- `php_packages`: A list of package names to be used by [APT][]. If you want [FPM][] support, `php5-fpm` **must** be in this list.
- `hwr_apt_default_release`: Release of debian to be used for package installation. (Ex: stable, backport, precise-stable, precise-backport)
- Key and repository management:
    - `hwr_apt_keys`: List of keys to be added to [APT][], each item must have the following attributes: `url` and `state`.
    - `hwr_apt_repositories`: List of repositories to be added to [APT][], each item must have the following attributes: `repo` and `state`

You can see an example of how to use it by taking a look on `vars/Debian-squeeze.yml` file.

### Using PHP-FPM

You can disable (it is enabled by default) installation and creation of
[PHP-FPM][fpm] pools setting `hwr_options.enable_fpm` to `no`.

By default, it will configure [FPM][] and create a pool pointing to
`/var/wwww/default`, which can be overwritten using `hwr_php_fpm_default_chdir`
variable.

You can set up how many pools you want, or just define a different `chdir` for
the default pool. More information on [FPM][] configuration and its pools below.

#### FPM configuration

File `php-fpm.conf` configuration is exposed through variables below.
Values below are all default values of the configuration file, you can
change just the ones you want to really overwrite.

    hwr_fpm_conf:
      pid: '/var/run/php5-fpm.pid'
      error_log: '/var/log/php5-fpm.log'
      log_level: 'notice'
      emergency_restart_threshold: 0
      emergency_restart_interval: 0
      process_control_timeout: 0
      daemonize: yes
      rlimit_files: 1024
      rlimit_core: 0
      events.mechanism: ** not set: autodetect **
      include: '/etc/php5/fpm/pool.d/*.conf'

The path to the configuration file is also configured though `hwr_path_php_fpm_ini`
variable, which is already defined depending on your operating system.

#### FPM pools

All pools kept by this role are defined under `hwr_fpm_pools` variable. It is a list
where each item is a different pool with all its configuration.

Each item (pool) can have [any valid configuration of a FPM pool][fpm-conf], the
default values are show below:

    hwr_fpm_pools:
        - name: default
          user: "{{ hwr_http_user }}"
          group: "{{ hwr_http_user_group }}"
          listen: 8000
          listen.allowed_clients: ""
          listen.backlog: 128
          listen.owner: "{{ hwr_http_user }}"
          listen.group: "{{ hwr_http_user_group }}"
          chdir: "/var/www/default"
          pm: dynamic
          pm.max_children: 10
          pm.start_servers: 2
          pm.min_spare_servers: 2
          pm.max_spare_servers: 5
          pm.process_idle_timeout: "10s"
          pm.max_requests: 0
          pm.status_path: "/status"
          access.log: "log/default.access.log"
          access.format: "%R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%%"

Variables `hwr_http_user` and `hwr_http_user_group` are defined on the OS variable
file, and should be used on every pool you create.

### `php.ini` configuration

You can manage `php.ini` configurations using `php_ini` variable. If you want to display
errors, for example:

```yml
# roles/my-php-role/group_vars/all.yml

php_ini:
    - section: "PHP"
      option: "display_errors"
      value: "On"
    - section: "PHP"
      option: "error_reporting"
      value: "-1"
```

Configurations will always be applied to the CLI `php.ini` file. If `php-fpm` is
enabled than its configuration will be changed too.

When you use a web server, you probably want to apply changes to another `php.ini`
files, this can be done with `php_ini_files` directive. It would look like this:

```yml
# roles/my-php-role/group_vars/all.yml

php_ini_files:
    - /etc/php5/apache2/php.ini
    - /etc/php5/nginx/php.ini
```

### Module configuration

| Variable              | Required | Value Type | Parent Variable       | Description |
|-----------------------|----------|------------|-----------------------|-------------|
| php_extensions_config | No       | list<dict> |                       | List of extension configurations. |
| file_name             | Yes      | string     | php_extensions_config | Name of the configuration file (ini) to be used. |
| extension_path        | Yes      | string     | php_extensions_config | Path of the extension to be loaded, used by `extension` configuration option. |
| <option name>         | No       | string     | php_extensions_config | Will be added into ini. |

Module configuration can be separated from `php.ini`, which is often the default
for some OSes (Debian family). You can use `php_extensions_config` variable to
manage these configurations.

These variable should contain a *lis* of *dicts*, if we want to manage [APC][]
configuration for example:

```yml
# roles/my-php-role/group_vars/all.yml

php_extensions_config:
    - file_name: apc.ini
      extension_path: apc.so
      apc.enable: 1
      apc.cache_by_default: 0
      apc.enable_cli: 1
      apc.write_lock: 0
```

By default, unmanaged extension configuration (and loading) will not be modified,
you can use `hwr_options.remove_unmanaged_extension_configuration` to enable removing
unmanaged extension configuration.

## Example playbook

    ---
    - hosts: all
      vars:
        hwr_php_fpm_default_chwdir: "/var/www"
        hwr_options.enable_fpm: yes
        php_ini:
          - section: "PHP"
            option: "display_errors"
            value: "On"
          - section: "PHP"
            option: "error_reporting"
            value: -1
          - section: "Date"
            option: "date.timezone"
            value: "America/Sao_Paulo"
        php_packages_extra:
            - mongodb
        php_pecl_packages:
            - mongo
            - timezonedb
        php_extensions_config:
          - filename: apc.ini
            extension_path: apc.so
            apc.cache_by_default: 0
            apc.enable_cli: 1
      roles:
        - { role: augustohp.php }

## License

[MIT][2]

## Author Information

- [Augusto Pascutti][3]

[1]: https://github.com/augustohp/ansible-role-php/blob/master/defaults/main.yml
[2]: https://github.com/augustohp/ansible-role-php/blob/master/LICENSE
[3]: https://github.com/augustohp
[fpm]: http://br1.php.net/manual/en/book.fpm.php "PHP Manual: FastCGI Process Manager"
[fpm-conf]: http://php.net/manual/en/install.fpm.configuration.php "PHP Manual: FPM Configuration"
[Debian]: http://www.debian.org/
[APT]: https://wiki.debian.org/Apt
[composer]: http://getcomposer.org "Composer"
[pecl]: http://pecl.php.net "PECL: The PHP Extension Community Library"
