#!/usr/bin/python3

try:
    from termcolor import colored

    print(colored("Hello, World!", "cyan", attrs=["bold", "underline"]))
    print(colored("This repository showcases beautiful terminal outputs!", "green", attrs=["bold"]))
except ImportError:
    print("Hello, World! (Install 'termcolor' for a more beautiful output)")
    print("This repository showcases beautiful terminal outputs! (Install 'termcolor' for a more beautiful output)")

