<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
  
<section id="in-contents">
		
		<!-- 탑 컨텐츠 -->
		<div class="top-row">
			<div class="lb">
				<select class="tx-select" onchange="if(this.value) location.href=(this.value);">
					<option value="index.html">종합현황</option>
					<option value="index_cate.html">1호기</option>
					<option value="index_cate.html">2호기</option>
					<option value="index_cate.html">3호기</option>
				</select>
			</div>

			<div class="rb">
				<ul class="m-t-info-ul">
					<li>
						<div class="icon">
							<img src="/resources/img/icon/icon_main_top01.png" alt="소나무 아이콘">
						</div>
						<div class="txt-b">
							<p class="t-p">
								소나무 <span class="sm">(단위 : 만)</span>
							</p>
							<p class="b-p">
								<span class="lg bold">40.33</span> 그루
							</p>
						</div>
					</li>
					<li>
						<div class="icon">
							<img src="/resources/img/icon/icon_main_top02.png" alt="CO2 아이콘">
						</div>
						<div class="txt-b">
							<p class="t-p">
								CO2감소량 <span class="sm">(단위 : 천)</span>
							</p>
							<p class="b-p">
								<span class="lg bold">1.12</span> Ton
							</p>
						</div>
					</li>
					<li>
						<div class="icon">
							<img src="/resources/img/icon/icon_main_top03.png" alt="날씨 아이콘">
						</div>
						<div class="deg-b">26º</div>
						<div class="txt-b">
							<p class="t-p">
								구름많음
							</p>
							<p class="b-p">
								<span class="sm">어제보다 3높아요. 체감온도 29</span>
							</p>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<!-- 탑 컨텐츠 끝 -->




		<!-- 밑에 주요 컨텐츠 -->
		<div class="bottom-major">
			
			<!-- 종합현황 -->
			<div class="m-situation-w">
				
				<!-- 첫번째 줄 -->
				<div class="col-1">

					<div class="r-1 gate-graph-box"> <!-- 첫번째! -->
						
						<div class="col-in"> <!-- col in -->
							<div class="gate-box">
								<div class="graph-b">
									<div id="jg1" class="gauge size-1"><svg height="100%" version="1.1" width="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="overflow: hidden; position: relative;" viewBox="0 0 200 100" preserveAspectRatio="xMidYMid meet"><desc style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">Created with Raphaël 2.2.0</desc><defs style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"><filter id="inner-shadow-jg1"><feOffset dx="0" dy="3"></feOffset><feGaussianBlur result="offset-blur" stdDeviation="5"></feGaussianBlur><feComposite operator="out" in="SourceGraphic" in2="offset-blur" result="inverse"></feComposite><feFlood flood-color="black" flood-opacity="0.2" result="color"></feFlood><feComposite operator="in" in="color" in2="inverse" result="shadow"></feComposite><feComposite operator="over" in="shadow" in2="SourceGraphic"></feComposite></filter></defs><path fill="#edebeb" stroke="none" d="M38,80L20,80A80,80,0,0,1,180,80L162,80A62,62,0,0,0,38,80Z" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path><path fill="#4a80c1" stroke="none" d="M38,80L20,80A80,80,0,0,1,58.801741432925176,11.423739595684822L68.07134961051702,26.85339818665574A62,62,0,0,0,38,80Z" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path><path fill="#000000" stroke="none" d="M74.93553844150925,34.395474273018266L71.5067254212935,36.455387201372005L53.65195911204082,2.8517070451454245Z" stroke-width="0" stroke-linecap="square" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); stroke-linecap: square;"></path><text x="100" y="78.43137254901961" text-anchor="middle" font-family="Arial" font-size="16px" stroke="none" fill="#010101" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 16px; font-weight: bold; fill-opacity: 1;" font-weight="bold" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">65.560</tspan></text><text x="100" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></tspan></text><text x="29" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">0</tspan></text><text x="171" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">200</tspan></text></svg></div>
								</div>
								<div class="txt-b">
									<h2><b>1,213.00</b>kWh</h2>
									<h5>당일 발전량</h5>
								</div>
							</div>

							<div class="number-box">
								<p class="n-t blue">10.5% <i class="xi-angle-up"></i></p>
								<div class="kwh-t">
									<h2><b>1,000.00</b>kWh</h2>
									<h5>전일 발전량 (증감율)</h5>
								</div>
							</div>
						</div> <!-- col in END -->
						
						<div class="col-in"> <!-- col in -->
							<div class="gate-box">
								<div class="graph-b">
									<div id="jg2" class="gauge size-1"><svg height="100%" version="1.1" width="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="overflow: hidden; position: relative; left: -0.515625px;" viewBox="0 0 200 100" preserveAspectRatio="xMidYMid meet"><desc style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">Created with Raphaël 2.2.0</desc><defs style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"><filter id="inner-shadow-jg2"><feOffset dx="0" dy="3"></feOffset><feGaussianBlur result="offset-blur" stdDeviation="5"></feGaussianBlur><feComposite operator="out" in="SourceGraphic" in2="offset-blur" result="inverse"></feComposite><feFlood flood-color="black" flood-opacity="0.2" result="color"></feFlood><feComposite operator="in" in="color" in2="inverse" result="shadow"></feComposite><feComposite operator="over" in="shadow" in2="SourceGraphic"></feComposite></filter></defs><path fill="#edebeb" stroke="none" d="M38,80L20,80A80,80,0,0,1,180,80L162,80A62,62,0,0,0,38,80Z" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path><path fill="#7fb439" stroke="none" d="M38,80L20,80A80,80,0,0,1,164.72135954999578,32.97717981660216L150.15905365124675,43.55731435786667A62,62,0,0,0,38,80Z" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path><path fill="#000000" stroke="none" d="M143.24445421208222,51.05320086954129L140.8933132029123,47.817132892041506L172.81152949374527,27.09932729367743Z" stroke-width="0" stroke-linecap="square" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); stroke-linecap: square;"></path><text x="100" y="78.43137254901961" text-anchor="middle" font-family="Arial" font-size="16px" stroke="none" fill="#010101" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 16px; font-weight: bold; fill-opacity: 1;" font-weight="bold" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">80.000</tspan></text><text x="100" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></tspan></text><text x="29" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">0</tspan></text><text x="171" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">100</tspan></text></svg></div>
								</div>
								<div class="txt-b">
									<h2><b>96</b>%</h2>
									<h5>현재 충전율(ESS)</h5>
								</div>
							</div>

							<div class="number-box">
								<p class="n-t blue">10.5% <i class="xi-angle-down"></i></p>
								<div class="tt-b">
									<h2>99.0%</h2>
									<h5>전일 충전률(ESS)(전일대비)</h5>
								</div>
								<div class="to-b">
									<p class="l-p">당일방전량</p>
									<p class="r-p"><b>113.00</b>kWh</p>
								</div>
							</div>
						</div> <!-- col in END -->

						
						<div class="col-in"> <!-- col in -->
							<div class="gate-box">
								<div class="graph-b">
									<div id="jg3" class="gauge size-1"><svg height="100%" version="1.1" width="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="overflow: hidden; position: relative; left: -0.03125px;" viewBox="0 0 200 100" preserveAspectRatio="xMidYMid meet"><desc style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">Created with Raphaël 2.2.0</desc><defs style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"><filter id="inner-shadow-jg3"><feOffset dx="0" dy="3"></feOffset><feGaussianBlur result="offset-blur" stdDeviation="5"></feGaussianBlur><feComposite operator="out" in="SourceGraphic" in2="offset-blur" result="inverse"></feComposite><feFlood flood-color="black" flood-opacity="0.2" result="color"></feFlood><feComposite operator="in" in="color" in2="inverse" result="shadow"></feComposite><feComposite operator="over" in="shadow" in2="SourceGraphic"></feComposite></filter></defs><path fill="#edebeb" stroke="none" d="M38,80L20,80A80,80,0,0,1,180,80L162,80A62,62,0,0,0,38,80Z" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path><path fill="#f9a51a" stroke="none" d="M38,80L20,80A80,80,0,0,1,124.7213595499958,3.915478696387723L119.15905365124675,21.03449598970048A62,62,0,0,0,38,80Z" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path><path fill="#000000" stroke="none" d="M117.97099674008759,31.16309514140191L114.16677067490697,29.927027163902125L127.81152949374527,-5.595086466563812Z" stroke-width="0" stroke-linecap="square" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); stroke-linecap: square;"></path><text x="100" y="78.43137254901961" text-anchor="middle" font-family="Arial" font-size="16px" stroke="none" fill="#010101" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 16px; font-weight: bold; fill-opacity: 1;" font-weight="bold" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">120.000</tspan></text><text x="100" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></tspan></text><text x="29" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">0</tspan></text><text x="171" y="91.43137254901961" text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="#b3b3b3" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: Arial; font-size: 10px; font-weight: normal; fill-opacity: 1;" font-weight="normal" fill-opacity="1"><tspan dy="0" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">200</tspan></text></svg></div>
								</div>
								<div class="txt-b">
									<h2><b>1,213.00</b>kWh</h2>
									<h5>당일 사용량</h5>
								</div>
							</div>

							<div class="number-box">
								<p class="n-t red">10.5% <i class="xi-angle-up"></i></p>
								<div class="kwh-t">
									<h2><b>1,000.00</b>kWh</h2>
									<h5>전일 사용량 (증감율)</h5>
								</div>
							</div>
						</div> <!-- col in END -->

					</div> <!-- 첫번째 END! --> 


					<div class="r-2 wide-graph-box"> <!-- 두번째! -->
						<div class="graph-title-box">
							<div class="lb">
								<p class="tit">에너지 발전/사용량 추이 그래프</p>
							</div>
							<div class="rb">
								<ul class="graph-cate">
									<li>
										<span class="squre" style="background-color:#5b5b5b"></span>
										<span class="txt">전일발전량</span>
									</li>
									<li>
										<span class="squre" style="background-color:#bfbdbe"></span>
										<span class="txt">전일발전량</span>
									</li>
									<li>
										<span class="squre" style="background-color:#29ace4"></span>
										<span class="txt">당일발전량</span>
									</li>
									<li>
										<span class="squre" style="background-color:#94ccdb"></span>
										<span class="txt">당일사용량</span>
									</li>
								</ul>
							</div>
						</div>

						<div class="graph-con">
							<div id="container" style="width: 100%; height: 100%; -webkit-tap-highlight-color: transparent; user-select: none; position: relative; background-color: transparent;" _echarts_instance_="ec_1609979571358"><div style="position: relative; overflow: hidden; width: 894px; height: 200px; cursor: default;"><canvas width="894" height="200" data-zr-dom-id="zr_0" style="position: absolute; left: 0px; top: 0px; width: 894px; height: 200px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></canvas></div><div style="position: absolute; display: none; border-style: solid; white-space: nowrap; z-index: 9999999; transition: left 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0s, top 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0s; background-color: rgba(50, 50, 50, 0.7); border-width: 0px; border-color: rgb(51, 51, 51); border-radius: 4px; color: rgb(255, 255, 255); font: 14px / 21px &quot;Microsoft YaHei&quot;; padding: 5px; left: 620.395px; top: -25px;">13<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#5b5b5b"></span>전일발전량 : 80<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#bfbdbe"></span>전일사용량 : 80<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#29ace4"></span>당일발전량 : 90<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#94ccdb"></span>당일사용량 : 90</div></div>
						</div>
					</div> <!-- 두번째 END! -->


					<div class="r-3 wide-graph-box"> <!-- 세번째! -->
						<div class="graph-title-box">
							<div class="lb">
								<p class="tit pdT5">목표대비 (kWh/시간)</p>
							</div>
							<div class="rb">
								<ul class="graph-cate">
									<li>
										<span class="squre" style="background-color:#29ace4"></span>
										<span class="txt">당일발전량</span>
									</li>
									<li>
										<span class="squre" style="background-color:#94ccdb"></span>
										<span class="txt">당일사용량</span>
									</li>
								</ul>
								<ul class="graph-day-tab-ul">
									<li class="active"><a href="javascript:;">일</a></li>
									<li><a href="javascript:;">주</a></li>
									<li><a href="javascript:;">월</a></li>
									<li><a href="javascript:;">년</a></li>
								</ul>
							</div>
						</div>

						<div class="graph-con">
							
							<div id="echart_line" style="width: 100%; height: 100%; -webkit-tap-highlight-color: transparent; user-select: none; position: relative; background-color: transparent;" _echarts_instance_="ec_1609979571359"><div style="position: relative; overflow: hidden; width: 894px; height: 200px; cursor: default;"><canvas width="894" height="200" data-zr-dom-id="zr_0" style="position: absolute; left: 0px; top: 0px; width: 894px; height: 200px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></canvas></div><div style="position: absolute; display: none; border-style: solid; white-space: nowrap; z-index: 9999999; transition: left 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0s, top 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0s; background-color: rgba(0, 0, 0, 0.5); border-width: 0px; border-color: rgb(51, 51, 51); border-radius: 4px; color: rgb(255, 255, 255); font: 14px / 21px Arial, Verdana, sans-serif; padding: 5px; left: 675.953px; top: 64px;">18<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#29ace4"></span>당일발전량 : 400<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#94ccdb"></span>당일사용량 : 830</div></div>
						</div>
					</div> <!-- 세번째 END! -->

				</div>



				<!-- 두번째 줄 -->
				<div class="col-2">
					
					<div class="r-1 half-graph-box"> <!-- 첫번째 -->
						<div class="title-box">
							<div class="lb">
								<ul class="tab-title-b blue">
									<li class="active"><a href="javascript:;">발전량</a></li>
									<li><a href="javascript:;">CO2절감량</a></li>
								</ul>
							</div>

							<div class="rb">								
								<ul class="graph-day-tab-ul blue">
									<li class="active"><a href="javascript:;">일</a></li>
									<li><a href="javascript:;">주</a></li>
									<li><a href="javascript:;">월</a></li>
									<li><a href="javascript:;">년</a></li>
								</ul>
							</div>
						</div>

						<div class="graph-in">
							<div class="info-b blue">
								<div class="one">
									<h5>시간당 평균 발전량</h5>
									<h2><b>1,370.00</b>kWh</h2>
								</div>
								<div class="one">
									<h5>일일 누적 발전량</h5>
									<h2><b>1,370.00</b>kWh</h2>
								</div>
								<div class="cate-b">
									<p>
										<span class="squre" style="background-color:#bbd7db"></span> 당일 발전량
									</p>
									<p>
										<span class="squre" style="background-color:#4b80c2"></span> 당일 사용량
									</p>
								</div>
							</div>

							<div class="graph-b">
								<p class="tit1">목표대비(kWh/시간)</p>
								<div class="in">
									<div id="echart_line2" style="width: 100%; height: 100%; -webkit-tap-highlight-color: transparent; user-select: none; position: relative; background-color: transparent;" _echarts_instance_="ec_1609979571360"><div style="position: relative; overflow: hidden; width: 320px; height: 161px; cursor: default;"><canvas width="320" height="161" data-zr-dom-id="zr_0" style="position: absolute; left: 0px; top: 0px; width: 320px; height: 161px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></canvas></div><div style="position: absolute; display: none; border-style: solid; white-space: nowrap; z-index: 9999999; transition: left 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0s, top 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0s; background-color: rgba(0, 0, 0, 0.5); border-width: 0px; border-color: rgb(51, 51, 51); border-radius: 4px; color: rgb(255, 255, 255); font: 14px / 21px Arial, Verdana, sans-serif; padding: 5px; left: 184.772px; top: 38px;">4<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#bbd7db"></span>당일발전량 : 830<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#4b80c2"></span>당일사용량 : 830</div></div>
								</div>
							</div>

						</div>
					</div> <!-- 첫번째 끝 -->
					

					<div class="r-1 half-graph-box"> <!-- 두번째 -->
						<div class="title-box">
							<div class="lb">
								<ul class="tab-title-b green">
									<li class="active"><a href="javascript:;">발전량</a></li>
									<li><a href="javascript:;">방전량</a></li>
								</ul>
							</div>

							<div class="rb">								
								<ul class="graph-day-tab-ul green">
									<li class="active"><a href="javascript:;">일</a></li>
									<li><a href="javascript:;">주</a></li>
									<li><a href="javascript:;">월</a></li>
									<li><a href="javascript:;">년</a></li>
								</ul>
							</div>
						</div>

						<div class="graph-in">
							<div class="info-b green">
								<div class="one">
									<h5>시간당 평균 발전량</h5>
									<h2><b>1,370.00</b>kWh</h2>
								</div>
								<div class="one">
									<h5>일일 누적 발전량</h5>
									<h2><b>1,370.00</b>kWh</h2>
								</div>
								<div class="cate-b">
									<p>
										<span class="squre" style="background-color:#e3e9c7"></span> 당일 발전량
									</p>
									<p>
										<span class="squre" style="background-color:#7fb439"></span> 당일 사용량
									</p>
								</div>
							</div>

							<div class="graph-b">
								<p class="tit1">ESS충전량(kWh/시간)</p>
								<div class="in">									
									<div id="echart_line3" style="width: 100%; height: 100%; -webkit-tap-highlight-color: transparent; user-select: none; position: relative; background-color: transparent;" _echarts_instance_="ec_1609979571361"><div style="position: relative; overflow: hidden; width: 320px; height: 161px; cursor: default;"><canvas width="320" height="161" data-zr-dom-id="zr_0" style="position: absolute; left: 0px; top: 0px; width: 320px; height: 161px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></canvas></div><div style="position: absolute; display: none; border-style: solid; white-space: nowrap; z-index: 9999999; transition: left 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0s, top 0.4s cubic-bezier(0.23, 1, 0.32, 1) 0s; background-color: rgba(0, 0, 0, 0.5); border-width: 0px; border-color: rgb(51, 51, 51); border-radius: 4px; color: rgb(255, 255, 255); font: 14px / 21px Arial, Verdana, sans-serif; padding: 5px; left: 99.3149px; top: 51px;">1<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#e3e9c7"></span>당일발전량 : 100<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#7fb439"></span>당일사용량 : 100</div></div>
								</div>
							</div>

						</div>
					</div> <!-- 두번째 끝 -->
					

					<div class="r-1 half-graph-box"> <!-- 세번째 -->
						<div class="title-box">

							<div class="rb">								
								<ul class="graph-day-tab-ul orange">
									<li class="active"><a href="javascript:;">일</a></li>
									<li><a href="javascript:;">주</a></li>
									<li><a href="javascript:;">월</a></li>
									<li><a href="javascript:;">년</a></li>
								</ul>
							</div>
						</div>

						<div class="graph-in">
							<div class="info-b orange">
								<div class="one">
									<h5>시간당 평균 발전량</h5>
									<h2><b>1,370.00</b>kWh</h2>
								</div>
								<div class="one">
									<h5>일일 누적 발전량</h5>
									<h2><b>1,370.00</b>kWh</h2>
								</div>
								<div class="cate-b">
									<p>
										<span class="squre" style="background-color:#fbd4b5"></span> 당일 발전량
									</p>
									<p>
										<span class="squre" style="background-color:#f9a51a"></span> 당일 사용량
									</p>
								</div>
							</div>

							<div class="graph-b">
								<p class="tit1">에너지 사용량(kWh/시간)</p>
								<div class="in">
									<div id="echart_line4" style="width: 100%; height: 100%; -webkit-tap-highlight-color: transparent; user-select: none; position: relative; background-color: transparent;" _echarts_instance_="ec_1609979571362"><div style="position: relative; overflow: hidden; width: 320px; height: 161px;"><canvas width="320" height="161" data-zr-dom-id="zr_0" style="position: absolute; left: 0px; top: 0px; width: 320px; height: 161px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></canvas></div><div></div></div>
								</div>
							</div>

						</div>
					</div> <!-- 세번째 끝 -->

				</div>




				<!-- 세번째 줄 -->
				<div class="col-3 ma-condition-box">

					<div class="one"> <!-- one -->
						<p class="tit">PV 발전</p>
						<div class="icon-box">
							<div class="half-b">
								<div class="icon">
									<span><img src="/resources/img/icon/icon_m_pv_blue.png" alt="pv발전 아이콘"></span>
									<span><img src="/resources/img/icon/icon_m_condi_gray.png" alt="작동오류 아이콘"></span>
								</div>
								<div class="name">1호기</div>
							</div>
							<div class="half-b">
								<div class="icon">
									<span><img src="/resources/img/icon/icon_m_pv_gray.png" alt="pv발전 아이콘"></span>
									<span><img src="/resources/img/icon/icon_m_condi_gray.png" alt="작동오류 아이콘"></span>
								</div>
								<div class="name">2호기</div>
							</div>
						</div>
					</div> <!-- one END -->

					<div class="one"> <!-- one -->
						<p class="tit">ESS(PCS) 상태</p>
						<div class="icon-box">
							<div class="half-b">
								<div class="icon">
									<span><img src="/resources/img/icon/icon_m_essPCS_blue.png" alt="ESS PCS 아이콘"></span>
									<span><img src="/resources/img/icon/icon_m_condi_gray.png" alt="작동오류 아이콘"></span>
								</div>
								<div class="name">1호기</div>
							</div>
							<div class="half-b">
								<div class="icon">
									<span><img src="/resources/img/icon/icon_m_essPCS_blue.png" alt="ESS PCS 아이콘"></span>
									<span><img src="/resources/img/icon/icon_m_condi_gray.png" alt="작동오류 아이콘"></span>
								</div>
								<div class="name">2호기</div>
							</div>
						</div>
					</div> <!-- one END -->

					<div class="one"> <!-- one -->
						<p class="tit">ESS(BAT) 상태</p>
						<div class="icon-box">
							<div class="half-b">
								<div class="icon">
									<span><img src="/resources/img/icon/icon_m_essBAT_gray.png" alt="ESS BAT 아이콘"></span>
									<span><img src="/resources/img/icon/icon_m_condi_red.png" alt="작동오류 아이콘"></span>
								</div>
								<div class="name">1호기</div>
							</div>
							<div class="half-b">
								<div class="icon">
									<span><img src="/resources/img/icon/icon_m_essBAT_blue.png" alt="ESS BAT 아이콘"></span>
									<span><img src="/resources/img/icon/icon_m_condi_gray.png" alt="작동오류 아이콘"></span>
								</div>
								<div class="name">2호기</div>
							</div>
						</div>
					</div> <!-- one END -->

				</div>

			</div>

		</div>
		<!-- 밑에 주요 컨텐츠 끝 -->


	</section>
<script type="text/javascript">
	var dom = document.getElementById("container");
	var myChart = echarts.init(dom);
	var app = {};
	option = null;
	option = {
	    tooltip : {
	        trigger: 'axis',
	        axisPointer : {            
	            type : 'shadow'        
	        }
	    },
	    legend: {
	    	show : false,
	        data:['전일발전량','전일사용량','당일발전량','당일사용량']
	    },
	    grid: {
	    	top:'15%',
	        left: '4%',
	        right: '4%',
	        bottom: '15%',
	        containLabel: true
	    },
	    xAxis : [
	        {
	            type : 'category',
	            data : [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19],
    			axisLine: { lineStyle: { color: '#aaa' }},
    			splitLine: { show: false },
	        }
	    ],
	    yAxis : [
	        {
	            type : 'value'
	        }
	    ],
	    series : [
	        {
	            name:'전일발전량',
	            type:'bar',
	            stack: '1',
	            barWidth : 5,
	            data:[50,60,70,80,90,50,60,70,80,90,50,60,70,80,90,50,60,70,80,90],
				itemStyle: { normal: { color: '#5b5b5b' } },
	        },
	        {
	            name:'전일사용량',
	            type:'bar',
	            stack: '1',
	            barWidth : 5,
	            data:[50,60,70,80,90,50,60,70,80,90,50,60,70,80,90,50,60,70,80,90],
				itemStyle: { normal: { color: '#bfbdbe' } },
	        },
	        {
	            name:'당일발전량',
	            type:'bar',
	            stack: '2',
	            barWidth : 5,
	            data:[60,70,50,90,100,60,70,50,90,100,60,70,50,90,100,60,70,50,90,100],
				itemStyle: { normal: { color: '#29ace4' } },
	        },
	        {
	            name:'당일사용량',
	            type:'bar',
	            stack: '2',
	            barWidth : 5,
	            data:[60,70,50,90,100,60,70,50,90,100,60,70,50,90,100,60,70,50,90,100],
				itemStyle: { normal: { color: '#94ccdb' } },
	        },
	    ]
	};
	if (option && typeof option === "object") {
	    myChart.setOption(option, true);
	}
</script>