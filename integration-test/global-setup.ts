import type { GlobalSetupContext } from 'vitest/node';
//import 'vitest';
import { PocketIcServer } from '@hadronous/pic';

let pic: PocketIcServer | undefined;

/*
declare module 'vitest' {
  export interface ProvidedContext {
    PIC_URL: string;
  }
}
*/

export async function setup({ provide }: GlobalSetupContext): Promise<void> {
  pic = await PocketIcServer.start();
  const url = pic.getUrl();

  provide('PIC_URL', url);
}

/*
export async function setup(): Promise<{ PIC_URL: string }> {
  pic = await PocketIcServer.start();
  const url = pic.getUrl();
  return { PIC_URL: url };
}
*/

export async function teardown(): Promise<void> {
  await pic?.stop();
}


/*
interface GlobalPocketICContext<T extends keyof ProvidedContext & string> extends GlobalSetupContext {
  provide(key: T, value: ProvidedContext[T]): void;
}
*/

//export async function setup({ provide }: GlobalPocketICContext<'PIC_URL'>): Promise<void> {

