# 📖 Kỳ Văn Viện (kyvanvien) - Ứng dụng đọc truyện chữ di động chuyên nghiệp

**Kỳ Văn Viện** là một ứng dụng di động đọc truyện chữ (tiểu thuyết, truyện dịch, truyện convert) hiện đại được xây dựng trên nền tảng **Flutter**. Ứng dụng cung cấp cho người đọc một giao diện mượt mà, nhiều tính năng tùy biến nâng cao trải nghiệm đọc, đồng thời tích hợp các tính năng tương tác như bình luận, tặng quà tác giả và thanh toán trực tuyến bảo mật qua Stripe.

---

## ✨ Tính năng nổi bật

### 1. Trải nghiệm đọc truyện tối ưu
*   **Chế độ đọc cá nhân hóa:** Hỗ trợ thay đổi kích thước chữ, chuyển đổi chương nhanh chóng.
*   **Chế độ bảo vệ mắt:** Giao diện đọc truyện sử dụng tông màu dịu nhẹ (`readpage`: `#F5EFE9` trong [colors.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/theme/colors.dart)), giảm mỏi mắt khi đọc ban đêm.
*   **Tải trang thông minh:** Hiển thị nội dung truyện định dạng HTML đầy đủ nhờ tích hợp `flutter_html`.

### 2. Quản lý thư viện cá nhân (Tủ sách)
*   **Lưu trữ thông minh (Bookcase):** Cho phép lưu lại các tác phẩm yêu thích để đọc sau.
*   **Theo dõi tiến trình:** Ghi nhớ chương đang đọc dở dang và cập nhật tiến trình đọc tự động.

### 3. Hệ thống Ví điện tử & Tặng quà (Gifts)
*   **Quản lý Ví (Wallet):** Theo dõi số dư xu và lịch sử giao dịch trực quan.
*   **Cửa hàng Quà tặng (Gift Shop):** Người đọc có thể mua và gửi tặng các phần quà ý nghĩa (Hoa, Nước ngọt, Tim, Kim cương...) cho tác giả để ủng hộ tinh thần sáng tác.
*   **Lịch sử tặng quà (Gift History):** Lưu trữ lịch sử tất cả các giao dịch tặng quà của tài khoản.

### 4. Cổng thanh toán Stripe bảo mật
*   Tích hợp trực tiếp **Stripe Payment SDK** (`flutter_stripe`) giúp người dùng nạp xu vào ví an toàn, nhanh chóng qua thẻ ngân hàng/thẻ quốc tế.

### 5. Tương tác cộng đồng
*   **Hệ thống bình luận (Comment Box):** Người dùng có thể viết đánh giá, thảo luận, bày tỏ ý kiến bên dưới mỗi truyện hoặc chương truyện.
*   **Đánh giá số sao (Rating Bar):** Hệ thống đánh giá chất lượng truyện 5 sao trực quan bằng `flutter_rating_bar`.

### 6. Quản lý tài khoản bảo mật
*   Hệ thống Đăng ký, Đăng nhập, Quên mật khẩu an toàn.
*   Sử dụng mã hóa mật khẩu phía client bằng **Bcrypt** và xác thực JWT token thông qua **Jaguar JWT**.
*   Lưu trạng thái đăng nhập lâu dài bằng **SharedPreferences**.

### 7. Tích hợp quảng cáo AdMob
*   Tích hợp **Google Mobile Ads** giúp hiển thị quảng cáo xen kẽ (Interstitial Ads) định kỳ để tạo doanh thu (monetization) mà không gây ảnh hưởng lớn đến trải nghiệm đọc của người dùng.

---

## 🛠️ Công nghệ sử dụng

| Công nghệ / Thư viện | Vai trò / Công dụng |
| :--- | :--- |
| **Flutter & Dart** | Khung phát triển ứng dụng đa nền tảng |
| **Stripe SDK** | Xử lý thanh toán thẻ trực tuyến an toàn |
| **Google Mobile Ads** | Hiển thị quảng cáo AdMob kiếm doanh thu |
| **SharedPreferences** | Lưu trữ cấu hình người dùng, lưu vết token đăng nhập |
| **Dio / Http** | Gọi API kết nối với hệ thống Backend |
| **Jaguar JWT & Bcrypt** | Xác thực Token JWT và mã hóa bảo mật thông tin |
| **Google Fonts** | Sử dụng font chữ Montserrat và các font hiện đại |

---

## 📂 Cấu trúc thư mục dự án

*   [lib/ad](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/ad): Quản lý quảng cáo AdMob ([ad_manager.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/ad/ad_manager.dart)).
*   [lib/components](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/components): Các widget UI dùng chung (Buttons, Story Tile, Story Banner).
*   [lib/gift](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/gift): Giao diện & Xử lý tính năng tặng quà tác giả.
*   [lib/images](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/images): Tài nguyên hình ảnh, asset tĩnh của ứng dụng.
*   [lib/models](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/models): Các lớp đối tượng (User, Story, Comment, History, Gift, Wallet).
*   [lib/payment](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/payment): Tích hợp thanh toán Stripe ([stripe_service.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/payment/stripe_service.dart), [pay_page.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/payment/pay_page.dart)).
*   [lib/theme](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/theme): Quản lý bảng màu ứng dụng ([colors.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/theme/colors.dart)).
*   [lib/ui](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/ui): Widget giao diện chuyên biệt cho Home và Chi tiết truyện.
*   [lib/view](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/view): Các trang (Pages) chính của ứng dụng.
    *   [lib/view/LoginRegister](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/view/LoginRegister): Xử lý Đăng ký, Đăng nhập, Token JWT.
    *   [home_page.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/view/home_page.dart): Giao diện trang chủ chứa truyện Hot, truyện Mới, truyện Hoàn thành.
    *   [menu_page.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/view/menu_page.dart): Thanh điều hướng BottomNavigationBar chính của app.
*   [main.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/main.dart): Điểm khởi chạy ứng dụng Flutter.

---

## 🚀 Hướng dẫn cài đặt & Chạy ứng dụng

### Yêu cầu hệ thống
*   **Flutter SDK**: `>=3.4.3 <4.0.0`
*   **Dart SDK** phù hợp đi kèm Flutter
*   Trình giả lập Android/iOS hoặc thiết bị thật đã bật chế độ gỡ lỗi (Developer Mode).

### Các bước khởi chạy

1.  **Tải mã nguồn về máy:**
    ```bash
    git clone <repository_url>
    cd kyvanvien
    ```

2.  **Cài đặt các gói phụ thuộc (Dependencies):**
    ```bash
    flutter pub get
    ```

3.  **Cấu hình API Keys:**
    *   Mở file cấu hình thanh toán tại [payment.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/payment/payment.dart) và thay thế mã Stripe Publishable Key của bạn:
        ```dart
        const String stripePublishableKey = "YOUR_STRIPE_PUBLISHABLE_KEY";
        ```
    *   Mở file [ad_manager.dart](file:///c:/Users/ngoma/Downloads/Nhom1_T2208A_Project4/Nhom1_T2208A_Project4/code_app/kyvanvien/lib/ad/ad_manager.dart) để cấu hình ID đơn vị quảng cáo AdMob thực tế thay thế cho ID thử nghiệm.

4.  **Chạy ứng dụng:**
    *   Khởi động thiết bị giả lập hoặc cắm điện thoại vào máy tính.
    *   Chạy lệnh sau trong thư mục gốc của dự án:
        ```bash
        flutter run
        ```

---

## 👥 Nhóm phát triển

Dự án được phát triển bởi **Nhom1_T2208A_Project4**.
