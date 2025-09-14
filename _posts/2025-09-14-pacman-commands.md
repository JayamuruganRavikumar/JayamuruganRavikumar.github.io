---
title: Pacman Commands
author: jay
date: "2025-09-14 02:44:52 +0200"
categories: [Cheatsheet, Tutorial]
tags: [linux]
render_with_liquid: false
toc: true
description: Basic pacaman commands.

---

### Basics

| Command                      | Description                                                   |
| ---                          | ---                                                           |
| `pacman -S <package name>`   | Install a package                                             |
| `pacman -R <package name>`   | Remove a package but keep the dependencies                    |
| `pacman -Rs <package name>`  | Remove a package and dependencies(not used by other packages) |
| `pacman -Rus <package name>` | Remove a package with all the packages that depend on it      |
| `pacman -Rn <package name>`  | Removes the package and its configuration files               |
| `pacman -Syy`                | Update Package list                                           |
| `pacman -Syu`                | Upgrade all the packages                                      |

### Package Info

| Command                      | Description                                                   |
| ---                          | ---                                                           |
| `pacman -Ss <package name>`  | Search for a package in the pacman database                   |
| `pacman -Si <package name>`  | Display information of the package                            |
| `pacman -Qs <package name>`  | Search for a installed package                                |
| `pacman -Qi <package name>`  | Display information of a installed package                    |
| `pacman -Ql <package name>`  | Retrive all the files installed by the package                |
| `pacman -Qk <package name>`  | Verify if the files installed are present                     |
| `pacman -Qdt`                | List all packages no longer required as dependencies          |
| `pacman -Sc`                 | Remove all the cached packages                                |
| `pacman -Sw <package name>`  | Download a package without installing                         |
| `pacman -U package`          | To install a package from local repo                          |

