<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">

    <title>메인페이지</title>
    <meta name="description" content="DAEYANG DASHBOARD">
    <meta property="og:title" content="메인페이지">
    <meta property="og:description" content="DAEYANG DASHBOARD">
    <meta property="og:locale" content="kr">
    <meta property="og:site_name" content="DAEYANG">

    <link rel="stylesheet" type="text/css" href="/resources/publish/_SFA/css/common.css">
  </head>

  <body>
    <div class="grid grid-cols-2 gap-1">
      <div style="background-image:url(/resources/img/safeAdmin/managements_background_image.png); background-position: center;"
        class="bg-cover bg-no-repeat h-screen object-cover cursor-pointer hover:filter hover:brightness-50">
        <a onclick="location.href='/sfa/safe/safeAdmin.do'">
          <div
            class="w-full h-full flex flex-col justify-center items-center text-white text-base md:text-base lg:text-lg md:text-5xl lg:text-7xl font-bold">
            <img src="/resources/img/icon/exclamationMarkWhite.svg" class="main-logo aspect-square m-2 md:m-6 lg:m-8"
              alt="안전관리 배경 이미지">안전관리
          </div>
        </a>
      </div>
      <div style="background-image:url(/resources/img/safeAdmin/tax_invoices_background_image.png); background-position: center;"
        class="bg-cover bg-no-repeat h-screen object-cover cursor-pointer hover:filter hover:brightness-50">
        <a onclick="location.href='/sfa/safe/billsAdmin.do'">
          <div
            class="w-full h-full flex flex-col justify-center items-center text-white text-base md:text-base lg:text-lg md:text-5xl lg:text-7xl font-bold">
            <img src="/resources/img/icon/taxInvoiceWhite.svg" class="main-logo aspect-square m-2 md:m-6 lg:m-8"
              alt="세금계산서 배경 이미지">세금계산서
          </div>
        </a>
      </div>
    </div>
    </div>

  </body>

</html>