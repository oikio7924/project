/**
 * PM2 배포 예시:
 *   pm2 start ecosystem.config.js
 *   pm2 save
 */
module.exports = {
  apps: [
    {
      name: "dm-web",
      script: "server.js",
      cwd: __dirname,
      instances: 1,
      exec_mode: "fork",
      watch: false,
      max_memory_restart: "512M",
      env: {
        NODE_ENV: "production",
        PORT: 3010,
      },
    },
  ],
};
