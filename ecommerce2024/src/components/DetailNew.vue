<template>
    <div class="container my-5">
      <!-- Tiêu đề bài viết -->
      <h1>{{ news.title }}</h1>
  
      <!-- Thông tin tác giả và ngày -->
      <div class="meta-info text-muted mb-4">
        <span>{{ news.date }}</span> | <span>{{ news.author }}</span>
      </div>
      <div v-if="news.type === 'opening_time'">
        <!-- Bảng nội dung tóm tắt -->
        <div class="content-summary">
          <div class="card mb-4 bg bg-primary-subtle">
            <div class="card-body">
              <h5 class="card-title text-center">Xem nhanh</h5>
              <ul>
                <li><a href="#feature1">Điểm nổi bật của {{ news.product }}</a></li>
                <li><a href="#feature2">Thiết kế, màn hình, hiệu năng</a></li>
                <li><a href="#feature3">Giá niêm yết</a></li>
              </ul>
            </div>
          </div>
        </div>
  
        <!-- Nội dung bài viết -->
        <h2 id="feature1" >Điểm nổi bật của {{ news.product }}</h2>
        <p v-html="formattedHighlights"></p>
  
        <h2 id="feature2">Thiết kế đẹp, màn hình lớn</h2>
        <p v-html="formattedDesignAndPerformance"></p>
  
        <h2 id="feature3">Giá niêm yết</h2>
        <ul>
          <li v-for="(price, index) in news.prices" :key="index">
            <strong>{{ price.model }}:</strong> {{ price.amount }} đồng
          </li>
        </ul>
      </div>
      <div v-else-if="news.type === 'test'">
        <!-- Bảng nội dung tóm tắt -->
        <div class="content-summary">
          <div class="card mb-4 bg bg-primary-subtle">
            <div class="card-body">
              <h5 class="card-title text-center">Xem nhanh</h5>
              <ul>
                <li><a href="#feature1">Thiết Kế</a></li>
                <li><a href="#feature2">Màn Hình</a></li>
                <li><a href="#feature3">Hiệu Năng</a></li>
                <li><a href="#feature4">Thời lượng pin</a></li>
                <li><a href="#feature5">Tông Kết</a></li>
              </ul>
            </div>
          </div>
        </div>
        <!-- Nội dung bài viết -->
        <h2 id="feature1" >Thiết Kế {{ news.product }}</h2>
        <p v-html="formatteddesign"></p>
  
        <h2 id="feature2">màn hình {{ news.product }}</h2>
        <p v-html="formattedscreen"></p>
  
        <h2 id="feature3">hiệu năng {{ news.product }}</h2>
        <p v-html="formattedperformance"></p>
  
        <h2 id="feature4">Thời lượng pin {{ news.product }}</h2>
        <p v-html="formattedpin"></p>
  
        <h2 id="feature5">Tổng Kết</h2>
        <p v-html="formattedend"></p>
      </div>
      <div v-else>
  
      </div>
      
      <!-- Form bình luận -->
       <h2>Viết Bình Luận Của Bạn</h2>
      <form @submit.prevent="submitComment">
        <div class="form-group">
          <label for="content">Nội dung</label>
          <textarea id="content" v-model="comment.content" class="form-control" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-danger">Gửi bình luận</button>
      </form>
    </div>
  </template>
  
  <script>
  export default {
    props: ['id'], // Nhận ID từ route params
    data() {
      return {
        newsList: [
          {
            id: 1,
            title: 'Chính thức mở bán Laptop RedmiBook 15, “mưa” ưa đãi, mua ngay thôi!',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            product: 'RedmiBook 15',
            type:'opening_time',
            featureHighlights:
              `Sở hữu laptop RedmiBook 15 là bạn đang sở hữu cho mình một chiếc máy với hiệu năng mạnh mẽ, sẵn sàng đồng hành cùng bạn trong mọi hành trình từ học tập đến làm việc. Với cả hai phiên bản đều sử dụng dòng chip Intel thế hệ 11 và 8GB RAM DDR4 sẵn sàng cùng bạn chinh phục mọi tác vụ dù là đơn nhân hay đa nhân.<br>
              Với phiên bản RedmiBook 15 sử dụng chip Intel Core i3-1115G4, 8GB RAM cùng ổ cứng SSD 256GB mang lại khả năng xử lý tốt những tác vụ cơ bản đến phức tạp. Dù bạn có mở hàng loạt tab hay nhiều ứng dụng, hoặc xử lý hàng ngàn dòng Excell thì máy vẫn đảm bảo khả năng xử lý nhanh chóng và mượt mà. <br>
              Ngoài ra ở phiên bản RedmiBook 15 sử dụng chip Intel Core i5-11300H sẽ sở hữu bộ nhớ trong SSD 512GB giúp tốc độ truy xuất dữ liệu nhanh chóng và khả năng lưu trữ nhiều hơn. Đặc biệt chip Intel Core i5 thế hệ 11 sở hữu dòng chip dòng H, là một dòng chip thiên về khả năng xử lý những tác vụ nặng như chơi game, đồ họa, dựng video. Nên bạn có thể yên tâm khi sử dụng con máy này để làm việc lẫn giải trí.`,
            designAndPerformance:
              `Sở hữu ngôn ngữ thiết kế hiện đại với các chi tiết được hoàn thiện tốt giúp chiếc máy này nhìn rất thời thượng. Cùng với màu tông tối, càng tạo cho RedmiBook 15 một vẻ đẹp cứng cáp và sang trọng. Bàn phím cũng được bố trí hợp lý, hành trình phím tốt cùng bàn di chuột rộng rãi mang đến cảm giác gõ và thao tác thoải mái. Đầy đủ cổng kết nối cũng là một điểm cộng trên con máy này, giúp bạn yên tâm làm việc và chia sẻ, truyền tải dữ liệu. <br>
              Màn hình 15.6 inch mang đến không gian hiển thị rộng rãi. Cùng với độ phân giải Full HD cho hình ảnh hiển thị rõ ràng sắc nét. Với màn hình chống chói và được trang bị DC Dimming bạn sẽ thoải mái làm việc với RedmiBook 15 mà không lo mỏi mắt. `,
            prices: [
              { model: 'Phiên bản i5-11300H/8GB/512GB', amount: '13,990,000' },
              { model: 'Phiên bản i7-11370H/16GB/512GB', amount: '15,990,000' }
            ],
          },
          {
            id: 2,
            title: 'Apple chính thức mở bán iPhone 14 tại Việt Nam ngày 14/10',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            product: 'iphone 14',
            type:'opening_time',
            featureHighlights:
              `Sở hữu laptop RedmiBook 15 là bạn đang sở hữu cho mình một chiếc máy với hiệu năng mạnh mẽ, sẵn sàng đồng hành cùng bạn trong mọi hành trình từ học tập đến làm việc. Với cả hai phiên bản đều sử dụng dòng chip Intel thế hệ 11 và 8GB RAM DDR4 sẵn sàng cùng bạn chinh phục mọi tác vụ dù là đơn nhân hay đa nhân.<br>
              Với phiên bản RedmiBook 15 sử dụng chip Intel Core i3-1115G4, 8GB RAM cùng ổ cứng SSD 256GB mang lại khả năng xử lý tốt những tác vụ cơ bản đến phức tạp. Dù bạn có mở hàng loạt tab hay nhiều ứng dụng, hoặc xử lý hàng ngàn dòng Excell thì máy vẫn đảm bảo khả năng xử lý nhanh chóng và mượt mà. <br>
              Ngoài ra ở phiên bản RedmiBook 15 sử dụng chip Intel Core i5-11300H sẽ sở hữu bộ nhớ trong SSD 512GB giúp tốc độ truy xuất dữ liệu nhanh chóng và khả năng lưu trữ nhiều hơn. Đặc biệt chip Intel Core i5 thế hệ 11 sở hữu dòng chip dòng H, là một dòng chip thiên về khả năng xử lý những tác vụ nặng như chơi game, đồ họa, dựng video. Nên bạn có thể yên tâm khi sử dụng con máy này để làm việc lẫn giải trí.`,
            designAndPerformance:
              `Sở hữu ngôn ngữ thiết kế hiện đại với các chi tiết được hoàn thiện tốt giúp chiếc máy này nhìn rất thời thượng. Cùng với màu tông tối, càng tạo cho RedmiBook 15 một vẻ đẹp cứng cáp và sang trọng. Bàn phím cũng được bố trí hợp lý, hành trình phím tốt cùng bàn di chuột rộng rãi mang đến cảm giác gõ và thao tác thoải mái. Đầy đủ cổng kết nối cũng là một điểm cộng trên con máy này, giúp bạn yên tâm làm việc và chia sẻ, truyền tải dữ liệu. <br>
              Màn hình 15.6 inch mang đến không gian hiển thị rộng rãi. Cùng với độ phân giải Full HD cho hình ảnh hiển thị rõ ràng sắc nét. Với màn hình chống chói và được trang bị DC Dimming bạn sẽ thoải mái làm việc với RedmiBook 15 mà không lo mỏi mắt. `,
            prices: [
              { model: 'Phiên bản i5-11300H/8GB/512GB', amount: '13,990,000' },
              { model: 'Phiên bản i7-11370H/16GB/512GB', amount: '15,990,000' }
            ],
          },
          {
            id: 3,
            title: 'Đánh giá HP ZBook Studio G11: Có gì để thuyết phục bạn bỏ ra tận 50 triệu đồng?',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            type:'test',
            product: 'laptop HP ZBook Studio G11',
            design:   `HP ZBook Studio G11 nổi bật với khung nhôm màu bạc sang trọng, tạo nên một điểm độc đáo riêng so với những chiếc laptop doanh nghiệp thường có màu đen truyền thống. Với độ dày chỉ 1.9 cm và trọng lượng khoảng 1.7 kg, máy rất mỏng nhẹ và dễ dàng mang theo bên mình. <br>
              Thiết kế của ZBook Studio không chỉ đẹp mắt mà còn mang lại cảm giác thoải mái hơn nhiều so với các laptop doanh nghiệp khác mà mình đã từng sử dụng. Đặc biệt, khi so sánh với Lenovo P1 Gen7, ZBook Studio tỏ ra vượt trội hơn về mặt thẩm mỹ.
              `,
            screen: `Đối với những người thường xuyên làm việc văn phòng, màn hình WUXGA, tần số quét 60HZ và chống lóa trên ZBook Studio là một lựa chọn hợp lý. Thông số này đủ để đáp ứng nhu cầu sử dụng hàng ngày như duyệt web, soạn thảo văn bản và giải trí cơ bản. Tuy nhiên, nếu bạn là người có nhu cầu về đồ họa hoặc chơi game, bạn có thể muốn cân nhắc các tùy chọn màn hình có độ phân giải cao hơn và tần số quét lớn hơn<br>
              Để có trải nghiệm nhìn tốt hơn, bạn nên chọn phiên bản màn hình WQUXGA. Bạn cũng có thể thêm tính năng cảm ứng ở với màn hình của G11, nhưng cá nhân mình thấy điều này không quá quan trọng.<br>
              Thật đáng tiếc khi HP ZBook Studio G11 chỉ trang bị duy nhất webcam 720p. Đây là một hạn chế đáng kể, đặc biệt khi xét đến mức giá cao cấp của sản phẩm và tầm quan trọng của các cuộc gọi video trong công việc hiện nay.<br>
              Chất lượng hình ảnh từ webcam này chỉ ở mức đủ dùng, dễ gặp khó khăn trong điều kiện ánh sáng yếu và khiến mình trông kém sắc trong các cuộc họp trực tuyến. Với một chiếc máy tính xách tay cao cấp năm 2024, người dùng hoàn toàn có quyền mong đợi một webcam chất lượng tốt hơn<br>
              HP đã thực hiện một cuộc đánh đổi thú vị trên ZBook G11 khi quyết định ưu tiên chất lượng âm thanh bằng cách loại bỏ bàn phím số. Hệ thống loa hướng lên mang đến trải nghiệm âm thanh đầy đặn, phong phú với dải âm rộng. <br>
              Tuy nhiên, âm lượng của loa hơi nhỏ đối với mình. Ngay cả khi chỉnh ở mức tối đa, âm lượng của Studio G11 vẫn có vẻ nhỏ hơn các laptop khác mà mình từng dùng.`,
            performance: `Một chiếc ZBook G11 bản cao cấp nhất sẽ được trang bị vi xử lý Ultra Core 9-185H và GPU RTX 4070 hoặc 3000 Ada, 64GB RAM DDR5, 4TB ROM và màn hình cảm ứng WQUXGA. Với các thông số hàng đầu như vậy, hiệu năng của G11 hoàn toàn đáp ứng tốt mọi nhu cầu của người dùng.<br>
              Điều khá lạ là hiệu năng của ZBook G11 lại không đồng đều trong các bài kiểm tra benchmark. Mặc dù máy đạt điểm số cao trong các bài kiểm tra đo lường hiệu năng đơn nhân và đa nhân của CPU, nhưng lại không thể hiện được sức mạnh tương tự trong các bài kiểm tra đánh giá hiệu năng tổng thể của hệ thống. Thậm chí, máy còn thua cả Acer Swift Go 16, một đối thủ có cấu hình thấp hơn trong một số bài kiểm tra.<br>
              Mặc dù kết quả benchmark cho thấy hiệu năng ấn tượng, nhưng trong quá trình sử dụng hàng ngày, ZBook G11 lại không ổn định. Khi thực hiện các tác vụ nặng như chỉnh sửa video 4K trên DaVinci Resolve, máy hoạt động rất tốt và xuất video nhanh. Tuy nhiên, trong các tác vụ hàng ngày như lướt web, sử dụng nhiều ứng dụng cùng lúc; G11 thỉnh thoảng bị chậm và lag.<br>
              `,
            pin: `Để duy trì thời lượng pin hợp lý, có vẻ như HP và các nhà sản xuất khác đã giảm hiệu suất đáng kể khi máy chạy bằng pin. Khi không cắm sạc, ZBook Studio chỉ đạt 2.357 điểm đơn nhân, 12.195 điểm đa nhân trên Geekbench 6 cùng với 6.749 điểm trong bài kiểm tra CPU của 3DMark.<br>
              Tuy nhiên, HP không giảm hiệu suất ZBook nhiều như Lenovo đã làm với ThinkPad P1. ThinkPad giảm hiệu suất tới 32% khi chuyển từ nguồn điện sang pin, trong khi ZBook chỉ giảm tối đa 19% trong các bài kiểm tra.<br>
              HP quảng cáo ZBook Studio G11 là một chiếc máy tính doanh nghiệp có khả năng chơi game khá tốt, nhưng mình không hoàn toàn đồng ý với lời quảng cáo này. Khi chơi Borderlands 2 ở độ phân giải cao và tần số quét 120Hz, máy hoạt động mượt mà khi cắm sạc.<br>
              Tuy nhiên, khi chuyển sang chế độ chạy bằng pin, G11 gặp tình trạng giật lag dù pin còn rất nhiều và mình đã cài đặt chế độ ưu tiên hiệu suất. Điều này khiến trải nghiệm chơi game trên chiếc laptop này không mấy thoải mái.`,
            end: `Việc quyết định có nên mua ZBook Studio G11 hay không thực sự là một vấn đề nan giải. Mặc dù sở hữu thiết kế đẹp mắt, hiệu năng mạnh mẽ và phù hợp với môi trường làm việc chuyên nghiệp, nhưng chiếc laptop này lại có một số hạn chế đáng kể so với mức giá của nó. <br>
              Nếu bạn ưu tiên một chiếc laptop có thiết kế đẹp mắt, hiệu năng cao và sẵn sàng bỏ ra một khoản tiền lớn, thì ZBook Studio G11 là một lựa chọn đáng cân nhắc. Tuy nhiên, nếu bạn chú trọng đến hiệu năng laptop phải đáng với từng đồng tiền; phải có một bàn phím và webcam tốt - G11 không phải là một sản phẩm lý tưởng cho bạn.`,
          },
          {
            id: 4,
            title: 'Đánh giá Xiaomi Redmi 14C: Một lựa chọn xứng đáng trong phân khúc 3 triệu đồng!',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            type:'test',
            product: 'Xiaomi Redmi 14C',
            design:   `HP ZBook Studio G11 nổi bật với khung nhôm màu bạc sang trọng, tạo nên một điểm độc đáo riêng so với những chiếc laptop doanh nghiệp thường có màu đen truyền thống. Với độ dày chỉ 1.9 cm và trọng lượng khoảng 1.7 kg, máy rất mỏng nhẹ và dễ dàng mang theo bên mình. <br>
              Thiết kế của ZBook Studio không chỉ đẹp mắt mà còn mang lại cảm giác thoải mái hơn nhiều so với các laptop doanh nghiệp khác mà mình đã từng sử dụng. Đặc biệt, khi so sánh với Lenovo P1 Gen7, ZBook Studio tỏ ra vượt trội hơn về mặt thẩm mỹ.
              `,
            screen: `Đối với những người thường xuyên làm việc văn phòng, màn hình WUXGA, tần số quét 60HZ và chống lóa trên ZBook Studio là một lựa chọn hợp lý. Thông số này đủ để đáp ứng nhu cầu sử dụng hàng ngày như duyệt web, soạn thảo văn bản và giải trí cơ bản. Tuy nhiên, nếu bạn là người có nhu cầu về đồ họa hoặc chơi game, bạn có thể muốn cân nhắc các tùy chọn màn hình có độ phân giải cao hơn và tần số quét lớn hơn<br>
              Để có trải nghiệm nhìn tốt hơn, bạn nên chọn phiên bản màn hình WQUXGA. Bạn cũng có thể thêm tính năng cảm ứng ở với màn hình của G11, nhưng cá nhân mình thấy điều này không quá quan trọng.<br>
              Thật đáng tiếc khi HP ZBook Studio G11 chỉ trang bị duy nhất webcam 720p. Đây là một hạn chế đáng kể, đặc biệt khi xét đến mức giá cao cấp của sản phẩm và tầm quan trọng của các cuộc gọi video trong công việc hiện nay.<br>
              Chất lượng hình ảnh từ webcam này chỉ ở mức đủ dùng, dễ gặp khó khăn trong điều kiện ánh sáng yếu và khiến mình trông kém sắc trong các cuộc họp trực tuyến. Với một chiếc máy tính xách tay cao cấp năm 2024, người dùng hoàn toàn có quyền mong đợi một webcam chất lượng tốt hơn<br>
              HP đã thực hiện một cuộc đánh đổi thú vị trên ZBook G11 khi quyết định ưu tiên chất lượng âm thanh bằng cách loại bỏ bàn phím số. Hệ thống loa hướng lên mang đến trải nghiệm âm thanh đầy đặn, phong phú với dải âm rộng. <br>
              Tuy nhiên, âm lượng của loa hơi nhỏ đối với mình. Ngay cả khi chỉnh ở mức tối đa, âm lượng của Studio G11 vẫn có vẻ nhỏ hơn các laptop khác mà mình từng dùng.`,
            performance: `Một chiếc ZBook G11 bản cao cấp nhất sẽ được trang bị vi xử lý Ultra Core 9-185H và GPU RTX 4070 hoặc 3000 Ada, 64GB RAM DDR5, 4TB ROM và màn hình cảm ứng WQUXGA. Với các thông số hàng đầu như vậy, hiệu năng của G11 hoàn toàn đáp ứng tốt mọi nhu cầu của người dùng.<br>
              Điều khá lạ là hiệu năng của ZBook G11 lại không đồng đều trong các bài kiểm tra benchmark. Mặc dù máy đạt điểm số cao trong các bài kiểm tra đo lường hiệu năng đơn nhân và đa nhân của CPU, nhưng lại không thể hiện được sức mạnh tương tự trong các bài kiểm tra đánh giá hiệu năng tổng thể của hệ thống. Thậm chí, máy còn thua cả Acer Swift Go 16, một đối thủ có cấu hình thấp hơn trong một số bài kiểm tra.<br>
              Mặc dù kết quả benchmark cho thấy hiệu năng ấn tượng, nhưng trong quá trình sử dụng hàng ngày, ZBook G11 lại không ổn định. Khi thực hiện các tác vụ nặng như chỉnh sửa video 4K trên DaVinci Resolve, máy hoạt động rất tốt và xuất video nhanh. Tuy nhiên, trong các tác vụ hàng ngày như lướt web, sử dụng nhiều ứng dụng cùng lúc; G11 thỉnh thoảng bị chậm và lag.<br>
              `,
            pin: `Để duy trì thời lượng pin hợp lý, có vẻ như HP và các nhà sản xuất khác đã giảm hiệu suất đáng kể khi máy chạy bằng pin. Khi không cắm sạc, ZBook Studio chỉ đạt 2.357 điểm đơn nhân, 12.195 điểm đa nhân trên Geekbench 6 cùng với 6.749 điểm trong bài kiểm tra CPU của 3DMark.<br>
              Tuy nhiên, HP không giảm hiệu suất ZBook nhiều như Lenovo đã làm với ThinkPad P1. ThinkPad giảm hiệu suất tới 32% khi chuyển từ nguồn điện sang pin, trong khi ZBook chỉ giảm tối đa 19% trong các bài kiểm tra.<br>
              HP quảng cáo ZBook Studio G11 là một chiếc máy tính doanh nghiệp có khả năng chơi game khá tốt, nhưng mình không hoàn toàn đồng ý với lời quảng cáo này. Khi chơi Borderlands 2 ở độ phân giải cao và tần số quét 120Hz, máy hoạt động mượt mà khi cắm sạc.<br>
              Tuy nhiên, khi chuyển sang chế độ chạy bằng pin, G11 gặp tình trạng giật lag dù pin còn rất nhiều và mình đã cài đặt chế độ ưu tiên hiệu suất. Điều này khiến trải nghiệm chơi game trên chiếc laptop này không mấy thoải mái.`,
            end: `Việc quyết định có nên mua ZBook Studio G11 hay không thực sự là một vấn đề nan giải. Mặc dù sở hữu thiết kế đẹp mắt, hiệu năng mạnh mẽ và phù hợp với môi trường làm việc chuyên nghiệp, nhưng chiếc laptop này lại có một số hạn chế đáng kể so với mức giá của nó. <br>
              Nếu bạn ưu tiên một chiếc laptop có thiết kế đẹp mắt, hiệu năng cao và sẵn sàng bỏ ra một khoản tiền lớn, thì ZBook Studio G11 là một lựa chọn đáng cân nhắc. Tuy nhiên, nếu bạn chú trọng đến hiệu năng laptop phải đáng với từng đồng tiền; phải có một bàn phím và webcam tốt - G11 không phải là một sản phẩm lý tưởng cho bạn.`,
          },
          {
            id: 5,
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G5',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            type:'opening_time',
            product: 'iphone 14',
            featureHighlights:
              `Sở hữu laptop RedmiBook 15 là bạn đang sở hữu cho mình một chiếc máy với hiệu năng mạnh mẽ, sẵn sàng đồng hành cùng bạn trong mọi hành trình từ học tập đến làm việc. Với cả hai phiên bản đều sử dụng dòng chip Intel thế hệ 11 và 8GB RAM DDR4 sẵn sàng cùng bạn chinh phục mọi tác vụ dù là đơn nhân hay đa nhân.<br>
              Với phiên bản RedmiBook 15 sử dụng chip Intel Core i3-1115G4, 8GB RAM cùng ổ cứng SSD 256GB mang lại khả năng xử lý tốt những tác vụ cơ bản đến phức tạp. Dù bạn có mở hàng loạt tab hay nhiều ứng dụng, hoặc xử lý hàng ngàn dòng Excell thì máy vẫn đảm bảo khả năng xử lý nhanh chóng và mượt mà. <br>
              Ngoài ra ở phiên bản RedmiBook 15 sử dụng chip Intel Core i5-11300H sẽ sở hữu bộ nhớ trong SSD 512GB giúp tốc độ truy xuất dữ liệu nhanh chóng và khả năng lưu trữ nhiều hơn. Đặc biệt chip Intel Core i5 thế hệ 11 sở hữu dòng chip dòng H, là một dòng chip thiên về khả năng xử lý những tác vụ nặng như chơi game, đồ họa, dựng video. Nên bạn có thể yên tâm khi sử dụng con máy này để làm việc lẫn giải trí.`,
            designAndPerformance:
              `Sở hữu ngôn ngữ thiết kế hiện đại với các chi tiết được hoàn thiện tốt giúp chiếc máy này nhìn rất thời thượng. Cùng với màu tông tối, càng tạo cho RedmiBook 15 một vẻ đẹp cứng cáp và sang trọng. Bàn phím cũng được bố trí hợp lý, hành trình phím tốt cùng bàn di chuột rộng rãi mang đến cảm giác gõ và thao tác thoải mái. Đầy đủ cổng kết nối cũng là một điểm cộng trên con máy này, giúp bạn yên tâm làm việc và chia sẻ, truyền tải dữ liệu. <br>
              Màn hình 15.6 inch mang đến không gian hiển thị rộng rãi. Cùng với độ phân giải Full HD cho hình ảnh hiển thị rõ ràng sắc nét. Với màn hình chống chói và được trang bị DC Dimming bạn sẽ thoải mái làm việc với RedmiBook 15 mà không lo mỏi mắt. `,
            prices: [
              { model: 'Phiên bản i5-11300H/8GB/512GB', amount: '13,990,000' },
              { model: 'Phiên bản i7-11370H/16GB/512GB', amount: '15,990,000' }
            ],
          },
          {
            id: 6,
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G5',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            type:'opening_time',
            product: 'iphone 14',
            featureHighlights:
              `Sở hữu laptop RedmiBook 15 là bạn đang sở hữu cho mình một chiếc máy với hiệu năng mạnh mẽ, sẵn sàng đồng hành cùng bạn trong mọi hành trình từ học tập đến làm việc. Với cả hai phiên bản đều sử dụng dòng chip Intel thế hệ 11 và 8GB RAM DDR4 sẵn sàng cùng bạn chinh phục mọi tác vụ dù là đơn nhân hay đa nhân.<br>
              Với phiên bản RedmiBook 15 sử dụng chip Intel Core i3-1115G4, 8GB RAM cùng ổ cứng SSD 256GB mang lại khả năng xử lý tốt những tác vụ cơ bản đến phức tạp. Dù bạn có mở hàng loạt tab hay nhiều ứng dụng, hoặc xử lý hàng ngàn dòng Excell thì máy vẫn đảm bảo khả năng xử lý nhanh chóng và mượt mà. <br>
              Ngoài ra ở phiên bản RedmiBook 15 sử dụng chip Intel Core i5-11300H sẽ sở hữu bộ nhớ trong SSD 512GB giúp tốc độ truy xuất dữ liệu nhanh chóng và khả năng lưu trữ nhiều hơn. Đặc biệt chip Intel Core i5 thế hệ 11 sở hữu dòng chip dòng H, là một dòng chip thiên về khả năng xử lý những tác vụ nặng như chơi game, đồ họa, dựng video. Nên bạn có thể yên tâm khi sử dụng con máy này để làm việc lẫn giải trí.`,
            designAndPerformance:
              `Sở hữu ngôn ngữ thiết kế hiện đại với các chi tiết được hoàn thiện tốt giúp chiếc máy này nhìn rất thời thượng. Cùng với màu tông tối, càng tạo cho RedmiBook 15 một vẻ đẹp cứng cáp và sang trọng. Bàn phím cũng được bố trí hợp lý, hành trình phím tốt cùng bàn di chuột rộng rãi mang đến cảm giác gõ và thao tác thoải mái. Đầy đủ cổng kết nối cũng là một điểm cộng trên con máy này, giúp bạn yên tâm làm việc và chia sẻ, truyền tải dữ liệu. <br>
              Màn hình 15.6 inch mang đến không gian hiển thị rộng rãi. Cùng với độ phân giải Full HD cho hình ảnh hiển thị rõ ràng sắc nét. Với màn hình chống chói và được trang bị DC Dimming bạn sẽ thoải mái làm việc với RedmiBook 15 mà không lo mỏi mắt. `,
            prices: [
              { model: 'Phiên bản i5-11300H/8GB/512GB', amount: '13,990,000' },
              { model: 'Phiên bản i7-11370H/16GB/512GB', amount: '15,990,000' }
            ],
          },
          {
            id: 7,
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G5',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            type:'opening_time',
            product: 'iphone 14',
            featureHighlights:
              `Sở hữu laptop RedmiBook 15 là bạn đang sở hữu cho mình một chiếc máy với hiệu năng mạnh mẽ, sẵn sàng đồng hành cùng bạn trong mọi hành trình từ học tập đến làm việc. Với cả hai phiên bản đều sử dụng dòng chip Intel thế hệ 11 và 8GB RAM DDR4 sẵn sàng cùng bạn chinh phục mọi tác vụ dù là đơn nhân hay đa nhân.<br>
              Với phiên bản RedmiBook 15 sử dụng chip Intel Core i3-1115G4, 8GB RAM cùng ổ cứng SSD 256GB mang lại khả năng xử lý tốt những tác vụ cơ bản đến phức tạp. Dù bạn có mở hàng loạt tab hay nhiều ứng dụng, hoặc xử lý hàng ngàn dòng Excell thì máy vẫn đảm bảo khả năng xử lý nhanh chóng và mượt mà. <br>
              Ngoài ra ở phiên bản RedmiBook 15 sử dụng chip Intel Core i5-11300H sẽ sở hữu bộ nhớ trong SSD 512GB giúp tốc độ truy xuất dữ liệu nhanh chóng và khả năng lưu trữ nhiều hơn. Đặc biệt chip Intel Core i5 thế hệ 11 sở hữu dòng chip dòng H, là một dòng chip thiên về khả năng xử lý những tác vụ nặng như chơi game, đồ họa, dựng video. Nên bạn có thể yên tâm khi sử dụng con máy này để làm việc lẫn giải trí.`,
            designAndPerformance:
              `Sở hữu ngôn ngữ thiết kế hiện đại với các chi tiết được hoàn thiện tốt giúp chiếc máy này nhìn rất thời thượng. Cùng với màu tông tối, càng tạo cho RedmiBook 15 một vẻ đẹp cứng cáp và sang trọng. Bàn phím cũng được bố trí hợp lý, hành trình phím tốt cùng bàn di chuột rộng rãi mang đến cảm giác gõ và thao tác thoải mái. Đầy đủ cổng kết nối cũng là một điểm cộng trên con máy này, giúp bạn yên tâm làm việc và chia sẻ, truyền tải dữ liệu. <br>
              Màn hình 15.6 inch mang đến không gian hiển thị rộng rãi. Cùng với độ phân giải Full HD cho hình ảnh hiển thị rõ ràng sắc nét. Với màn hình chống chói và được trang bị DC Dimming bạn sẽ thoải mái làm việc với RedmiBook 15 mà không lo mỏi mắt. `,
            prices: [
              { model: 'Phiên bản i5-11300H/8GB/512GB', amount: '13,990,000' },
              { model: 'Phiên bản i7-11370H/16GB/512GB', amount: '15,990,000' }
            ],
          },
          {
            id: 8,
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G5',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            type:'opening_time',
            product: 'iphone 14',
            featureHighlights:
              `Sở hữu laptop RedmiBook 15 là bạn đang sở hữu cho mình một chiếc máy với hiệu năng mạnh mẽ, sẵn sàng đồng hành cùng bạn trong mọi hành trình từ học tập đến làm việc. Với cả hai phiên bản đều sử dụng dòng chip Intel thế hệ 11 và 8GB RAM DDR4 sẵn sàng cùng bạn chinh phục mọi tác vụ dù là đơn nhân hay đa nhân.<br>
              Với phiên bản RedmiBook 15 sử dụng chip Intel Core i3-1115G4, 8GB RAM cùng ổ cứng SSD 256GB mang lại khả năng xử lý tốt những tác vụ cơ bản đến phức tạp. Dù bạn có mở hàng loạt tab hay nhiều ứng dụng, hoặc xử lý hàng ngàn dòng Excell thì máy vẫn đảm bảo khả năng xử lý nhanh chóng và mượt mà. <br>
              Ngoài ra ở phiên bản RedmiBook 15 sử dụng chip Intel Core i5-11300H sẽ sở hữu bộ nhớ trong SSD 512GB giúp tốc độ truy xuất dữ liệu nhanh chóng và khả năng lưu trữ nhiều hơn. Đặc biệt chip Intel Core i5 thế hệ 11 sở hữu dòng chip dòng H, là một dòng chip thiên về khả năng xử lý những tác vụ nặng như chơi game, đồ họa, dựng video. Nên bạn có thể yên tâm khi sử dụng con máy này để làm việc lẫn giải trí.`,
            designAndPerformance:
              `Sở hữu ngôn ngữ thiết kế hiện đại với các chi tiết được hoàn thiện tốt giúp chiếc máy này nhìn rất thời thượng. Cùng với màu tông tối, càng tạo cho RedmiBook 15 một vẻ đẹp cứng cáp và sang trọng. Bàn phím cũng được bố trí hợp lý, hành trình phím tốt cùng bàn di chuột rộng rãi mang đến cảm giác gõ và thao tác thoải mái. Đầy đủ cổng kết nối cũng là một điểm cộng trên con máy này, giúp bạn yên tâm làm việc và chia sẻ, truyền tải dữ liệu. <br>
              Màn hình 15.6 inch mang đến không gian hiển thị rộng rãi. Cùng với độ phân giải Full HD cho hình ảnh hiển thị rõ ràng sắc nét. Với màn hình chống chói và được trang bị DC Dimming bạn sẽ thoải mái làm việc với RedmiBook 15 mà không lo mỏi mắt. `,
            prices: [
              { model: 'Phiên bản i5-11300H/8GB/512GB', amount: '13,990,000' },
              { model: 'Phiên bản i7-11370H/16GB/512GB', amount: '15,990,000' }
            ],
          },
          {
            id: 9,
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G5',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            type:'opening_time',
            product: 'iphone 14',
            featureHighlights:
              `Sở hữu laptop RedmiBook 15 là bạn đang sở hữu cho mình một chiếc máy với hiệu năng mạnh mẽ, sẵn sàng đồng hành cùng bạn trong mọi hành trình từ học tập đến làm việc. Với cả hai phiên bản đều sử dụng dòng chip Intel thế hệ 11 và 8GB RAM DDR4 sẵn sàng cùng bạn chinh phục mọi tác vụ dù là đơn nhân hay đa nhân.<br>
              Với phiên bản RedmiBook 15 sử dụng chip Intel Core i3-1115G4, 8GB RAM cùng ổ cứng SSD 256GB mang lại khả năng xử lý tốt những tác vụ cơ bản đến phức tạp. Dù bạn có mở hàng loạt tab hay nhiều ứng dụng, hoặc xử lý hàng ngàn dòng Excell thì máy vẫn đảm bảo khả năng xử lý nhanh chóng và mượt mà. <br>
              Ngoài ra ở phiên bản RedmiBook 15 sử dụng chip Intel Core i5-11300H sẽ sở hữu bộ nhớ trong SSD 512GB giúp tốc độ truy xuất dữ liệu nhanh chóng và khả năng lưu trữ nhiều hơn. Đặc biệt chip Intel Core i5 thế hệ 11 sở hữu dòng chip dòng H, là một dòng chip thiên về khả năng xử lý những tác vụ nặng như chơi game, đồ họa, dựng video. Nên bạn có thể yên tâm khi sử dụng con máy này để làm việc lẫn giải trí.`,
            designAndPerformance:
              `Sở hữu ngôn ngữ thiết kế hiện đại với các chi tiết được hoàn thiện tốt giúp chiếc máy này nhìn rất thời thượng. Cùng với màu tông tối, càng tạo cho RedmiBook 15 một vẻ đẹp cứng cáp và sang trọng. Bàn phím cũng được bố trí hợp lý, hành trình phím tốt cùng bàn di chuột rộng rãi mang đến cảm giác gõ và thao tác thoải mái. Đầy đủ cổng kết nối cũng là một điểm cộng trên con máy này, giúp bạn yên tâm làm việc và chia sẻ, truyền tải dữ liệu. <br>
              Màn hình 15.6 inch mang đến không gian hiển thị rộng rãi. Cùng với độ phân giải Full HD cho hình ảnh hiển thị rõ ràng sắc nét. Với màn hình chống chói và được trang bị DC Dimming bạn sẽ thoải mái làm việc với RedmiBook 15 mà không lo mỏi mắt. `,
            prices: [
              { model: 'Phiên bản i5-11300H/8GB/512GB', amount: '13,990,000' },
              { model: 'Phiên bản i7-11370H/16GB/512GB', amount: '15,990,000' }
            ],
          },
          {
            id: 10,
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G5',
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            type:'opening_time',
            product: 'iphone 14',
            featureHighlights:
              `Sở hữu laptop RedmiBook 15 là bạn đang sở hữu cho mình một chiếc máy với hiệu năng mạnh mẽ, sẵn sàng đồng hành cùng bạn trong mọi hành trình từ học tập đến làm việc. Với cả hai phiên bản đều sử dụng dòng chip Intel thế hệ 11 và 8GB RAM DDR4 sẵn sàng cùng bạn chinh phục mọi tác vụ dù là đơn nhân hay đa nhân.<br>
              Với phiên bản RedmiBook 15 sử dụng chip Intel Core i3-1115G4, 8GB RAM cùng ổ cứng SSD 256GB mang lại khả năng xử lý tốt những tác vụ cơ bản đến phức tạp. Dù bạn có mở hàng loạt tab hay nhiều ứng dụng, hoặc xử lý hàng ngàn dòng Excell thì máy vẫn đảm bảo khả năng xử lý nhanh chóng và mượt mà. <br>
              Ngoài ra ở phiên bản RedmiBook 15 sử dụng chip Intel Core i5-11300H sẽ sở hữu bộ nhớ trong SSD 512GB giúp tốc độ truy xuất dữ liệu nhanh chóng và khả năng lưu trữ nhiều hơn. Đặc biệt chip Intel Core i5 thế hệ 11 sở hữu dòng chip dòng H, là một dòng chip thiên về khả năng xử lý những tác vụ nặng như chơi game, đồ họa, dựng video. Nên bạn có thể yên tâm khi sử dụng con máy này để làm việc lẫn giải trí.`,
            designAndPerformance:
              `Sở hữu ngôn ngữ thiết kế hiện đại với các chi tiết được hoàn thiện tốt giúp chiếc máy này nhìn rất thời thượng. Cùng với màu tông tối, càng tạo cho RedmiBook 15 một vẻ đẹp cứng cáp và sang trọng. Bàn phím cũng được bố trí hợp lý, hành trình phím tốt cùng bàn di chuột rộng rãi mang đến cảm giác gõ và thao tác thoải mái. Đầy đủ cổng kết nối cũng là một điểm cộng trên con máy này, giúp bạn yên tâm làm việc và chia sẻ, truyền tải dữ liệu. <br>
              Màn hình 15.6 inch mang đến không gian hiển thị rộng rãi. Cùng với độ phân giải Full HD cho hình ảnh hiển thị rõ ràng sắc nét. Với màn hình chống chói và được trang bị DC Dimming bạn sẽ thoải mái làm việc với RedmiBook 15 mà không lo mỏi mắt. `,
            prices: [
              { model: 'Phiên bản i5-11300H/8GB/512GB', amount: '13,990,000' },
              { model: 'Phiên bản i7-11370H/16GB/512GB', amount: '15,990,000' }
            ],
          },
          // Thêm các bài viết khác
        ],
        comment: {
          content: '',
        },
        news: {}
      };
    },
    computed: {
        formattedHighlights() {
            return (this.news.featureHighlights || '').replace(/\n/g, '<br>');
        },
        formattedDesignAndPerformance() {
          return (this.news.designAndPerformance || '').replace(/\n/g, '<br>');
        },
        formatteddesign() {
            return (this.news.design || '').replace(/\n/g, '<br>');
        },
        formattedscreen() {
            return (this.news.screen || '').replace(/\n/g, '<br>');
        },
        formattedperformance() {
            return (this.news.performance || '').replace(/\n/g, '<br>');
        },
        formattedpin() {
            return (this.news.pin || '').replace(/\n/g, '<br>');
        },
        formattedend() {
            return (this.news.end || '').replace(/\n/g, '<br>');
        },
    },
    mounted() {
      this.news = this.newsList.find(news => news.id === Number(this.id));
    },
    methods: {
      submitComment() {
        console.log('Bình luận đã được gửi:', this.comment);
        this.comment.content = '';
      }
    }
  };
  </script>
  <style scoped>
  .meta-info {
    font-size: 14px;
  }
  .content-summary {
    max-width: 400px; /* Giới hạn chiều rộng */
  }
  .card {
    border: 1px solid #ddd;
  }
  .card-body ul {
    padding-left: 20px;
  }
  .social-share a {
    margin-right: 10px;
  }
  </style>