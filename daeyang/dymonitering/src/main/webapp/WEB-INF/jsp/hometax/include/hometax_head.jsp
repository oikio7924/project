<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>홈택스 세금계산서</title>
<style>
  * { box-sizing: border-box; }
  html, body { margin: 0; height: 100%; overflow: hidden; font-family: 'Malgun Gothic', sans-serif; }
  .hometax-wrap { display: flex; height: 100vh; min-height: 0; overflow: hidden; }
  .hometax-side { width: 220px; flex-shrink: 0; background: #2c3e50; color: #fff; padding: 1rem 0; }
  .hometax-side a { display: block; padding: 12px 20px; color: #ecf0f1; text-decoration: none; }
  .hometax-side a:hover { background: #34495e; }
  .hometax-side a.on { background: #1abc9c; color: #fff; }
  .hometax-side .logout { margin-top: 1rem; border-top: 1px solid #34495e; padding-top: 1rem; }
  .hometax-main { flex: 1; padding: 1rem; background: #ecf0f1; min-width: 0; min-height: 0; display: flex; flex-direction: column; overflow: hidden; }
</style>
