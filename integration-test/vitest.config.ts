import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    root: "tests",
    globalSetup: './global-setup.ts',
    testTimeout: 30_000,
  },
});