import { Scenes, session } from "telegraf";
import { WizardContext } from "@app/functions/telegraf";
import bot from "@app/functions/telegraf";
import { transactionWizard } from "./transaction_wizard";

const stage = new Scenes.Stage<WizardContext>([transactionWizard]);
bot.use(session());
bot.use(stage.middleware());

export { bot };
