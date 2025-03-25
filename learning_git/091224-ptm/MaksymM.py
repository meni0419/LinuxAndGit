#!/usr/bin/env python3

import time

# ANSI-коды цветов
YELLOW = '\033[93m'
BLACK = '\033[30m'
CYAN = '\033[96m'
GREEN = '\033[92m'
RESET = '\033[0m'

# Цветной логотип Linux
linux_logo = [
    f"{YELLOW}       .--.",
    f"{YELLOW}      |{BLACK}o_o{YELLOW} |",
    f"{YELLOW}      |{BLACK}:_/{YELLOW} |",
    f"{YELLOW}     //   \\ \\",
    f"{YELLOW}    (|     | )",
    f"{YELLOW}   /'\\_   _/`\\",
    f"{YELLOW}   \\___)=(___)/{RESET}"
]

# Вывод логотипа
for line in linux_logo:
    print(line)
    time.sleep(0.1)

# Печать приветственного сообщения
print()
print(f"{CYAN}Добро пожаловать в мир Linux!{RESET} ")
print()

# Эффект печатающегося текста
typing_text = "Система загружена и готова к работе... "
for char in typing_text:
    print(f"{GREEN}{char}{RESET}", end="", flush=True)
    time.sleep(0.05)

print("\n")