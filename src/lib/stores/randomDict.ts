import type { Character } from "$lib/constants/characters";

// ===== 起動メッセージ辞書 =====
export const bootMessages: Record<Character, string[]> = {
  muryi: [
    "[SYS] BOOT-SEQ. START.",
    "同期開始〜♪",
    "同期OK〜♪ ミュリィ、今日もガワもコアもkawaii-！",
  ],
  piona: [
    "[SYS] BOOT",
    "起動チェック完了！今日もいくよ！",
  ],
  menoa: [
    "[SYS] CORE-ANALYZE",
    "状況を解析中。",
    "本日も冷静に参りましょう。",
  ],
  ciel: [
    "[SYS] LINK: ONLINE",
    "回線接続、正常。",
    "今日のタスク、最適化済み。",
  ],
  sys: [
    "[SYS] SYSTEM-ONLINE.",
  ]
};

// ===== ランダム応答辞書 =====
export const randomDict: Record<Character, string[]> = {
    muryi: ["了解～！", "任せて♪", "ガワもコアもkawaii！"],
    piona: ["はーい！", "OK！", "やるよ！"],
    menoa: ["承認しました。", "処理を開始します。", "安定稼働中です。"],
    ciel: ["了解。", "処理します。", "最適化中です。"],
    sys: ["SYSTEM OK", "TASK ACCEPTED", "RUNNING..."],
};
