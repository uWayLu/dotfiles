#!/usr/bin/env python3
"""Smart paste: text as-is, clipboard images saved to ~/Pictures/_clipboard."""

from __future__ import annotations

import importlib.machinery
import shlex
from pathlib import Path

from kittens.tui.handler import result_handler
from kitty.boss import Boss

CLIPIMG = Path.home() / ".local" / "bin" / "clipimg-from-clipboard"


def load_clipimg_module():
    if not CLIPIMG.is_file():
        raise RuntimeError(f"cannot find {CLIPIMG}")
    return importlib.machinery.SourceFileLoader(
        "clipimg_from_clipboard",
        str(CLIPIMG),
    ).load_module()


def main(args: list[str]) -> None:
    pass


def has_image_mime(mimes: tuple[str, ...]) -> bool:
    return any(mime.lower().startswith("image/") for mime in mimes)


def shell_safe_path(path: str) -> str:
    return shlex.quote(path)


@result_handler(no_ui=True)
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss) -> None:
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    try:
        mimes = boss.clipboard.get_available_mime_types_for_paste()
    except Exception as exc:
        boss.show_error("智慧貼上失敗", f"無法讀取剪貼簿 MIME 類型：{exc}")
        return

    if has_image_mime(mimes):
        if not CLIPIMG.is_file():
            boss.show_error("智慧貼上失敗", f"找不到腳本：{CLIPIMG}")
            return
        try:
            clipimg = load_clipimg_module()
            image_path = str(clipimg.save_clipboard_image_from_boss(boss.clipboard))
            window.paste_text(shell_safe_path(image_path))
            return
        except Exception:
            pass

    try:
        text = boss.clipboard.get_text()
    except Exception as exc:
        boss.show_error("智慧貼上失敗", f"無法讀取剪貼簿文字：{exc}")
        return

    if text:
        window.paste_text(text)
        return

    boss.show_error(
        "智慧貼上失敗",
        "剪貼簿中沒有可用文字或圖片。\n"
        "若這是第一次讀取剪貼簿，請在 kitty 權限提示中允許 read-clipboard。",
    )
