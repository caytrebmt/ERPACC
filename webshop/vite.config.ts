import tailwindcss from '@tailwindcss/vite';
import react from '@vitejs/plugin-react';
import path from 'path';
import { defineConfig, loadEnv } from 'vite';

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');

  const ERPACC_BACKEND =
    env.VITE_ERPACC_BACKEND_URL || 'http://localhost:5000';

  return {
    plugins: [react(), tailwindcss()],

    resolve: {
      alias: {
        '@': path.resolve(__dirname, '.'),
      },
    },

    server: {
      port: 3000,

      proxy: {
        '/api/shop': {
          target: ERPACC_BACKEND,
          changeOrigin: true,
        },

        '/static': {
          target: ERPACC_BACKEND,
          changeOrigin: true,
        },
      },

      hmr: process.env.DISABLE_HMR !== 'true',

      watch:
        process.env.DISABLE_HMR === 'true'
          ? null
          : {},
    },
  };
});
