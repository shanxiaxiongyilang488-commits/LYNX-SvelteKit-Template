// ===============================
// AI返信ロジック（キャラクターごとの返し方）
// ===============================

export const characterResponses: Record<string, (input: string) => string> = {
    muryi: (input: string) => {
        return `ミュリィ：「ガワもコアもkawaiiだよ〜♡」 → ${input}`;
    },

    piona: (input: string) => {
        return `ピオナ：「今日も元気に頑張るよ！」 → ${input}`;
    },

    menoa: (input: string) => {
        return `メノア：「解析完了。入力：${input}」`;
    },

    ciel: (input: string) => {
        return `シエル（解析結果）：${input}`;
    },

    sys: (input: string) => {
        return `SYSTEM：${input}`;
    },

    default: (input: string) => {
        return `AI応答：${input}`;
    }
};


// ===============================
// 返答生成：キャラに応じた関数を呼び出す
// ===============================

export function getRandomResponse(character: string, input: string) {
    const fn =
        characterResponses[character] ??
        characterResponses.default;
    return fn(input);
}
