import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    root: "tests",
    //setupFiles: ['./setup.ts'],
    globalSetup: './global-setup.ts',
    testTimeout: 30_000,
  },
});