import { bot } from "@app/functions/wizards";

bot.action("send_token", async (ctx) => {
	await ctx.scene.enter("transaction-wizard");
});

export { bot };
