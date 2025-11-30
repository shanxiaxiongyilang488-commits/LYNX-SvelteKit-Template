console.log("起動時 KEY =", OPENAI_API_KEY);

import { json, type RequestEvent } from '@sveltejs/kit';
import { OPENAI_API_KEY } from '$env/static/private';

export async function POST(event: RequestEvent) {
    // ★ ここが最重要修正点 — () を付ける！
    const { message: userText } = await event.request.json();

    console.log("API受信 message =", userText);

    const res = await fetch("https://api.openai.com/v1/chat/completions", {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${OPENAI_API_KEY}`,
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            model: "gpt-4o-mini",
            messages: [
                { role: "user", content: userText }
            ]
        })
    });

    const data = await res.json();
    console.log("OpenAI応答 =", JSON.stringify(data, null, 2));  // ★これ
    return json(data, { status: 200 });

}
