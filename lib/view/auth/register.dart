import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/auth/login_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DateTime? _selectedDate;
  final TextEditingController _dobController = TextEditingController();
  bool _obscurePassword = true;

  //Kiểm tra email
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  //Kiểm tra username
  final TextEditingController _usernameController = TextEditingController();
  String? _usernameError;

  //Kiểm tra password
  final TextEditingController _passwordController = TextEditingController();
  final bool _obscurePassword1 = true;
  String? _passwordError;

  //Kiểm tra định dạng hình ảnh
  final TextEditingController _imageUrlController = TextEditingController();
  String? _imageUrlError;

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate ?? DateTime(2000, 1, 1),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    helpText: 'Chọn ngày sinh',
     builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(0xFFFF5722),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF5722),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      _selectedDate = picked;
      _dobController.text = formatDate(picked);  
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              //Đăng ký tài khoản
              const Text(
                'ĐĂNG KÝ TÀI KHOẢN',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5722),
                ),
              ),
              const SizedBox(height: 8),

              //Dòng thông báo
              const Text(
                'Vui lòng điền đầy đủ thông tin bên dưới',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),

              // Họ tên
              TextField(
                decoration: InputDecoration(
                  labelText: "Họ tên",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.person),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                    hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Ngày sinh
              TextField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: "Ngày sinh",
                  hintText: "dd/mm/yyyy",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.calendar_today),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Địa chỉ
              TextField(
                decoration: InputDecoration(
                  labelText: "Nơi ở",
                  hintText: "Số nhà, tên đường, phường, tỉnh/ thành",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.location_on),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                    hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                  if (value.isEmpty || emailPattern.hasMatch(value)) {
                    _emailError = null;
                  } else {
                    _emailError = 'Email phải có định dạng hợp lệ và kết thúc bằng @gmail.com';
                  }
                  setState(() {}); // Cập nhật UI
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: _emailError,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                  errorMaxLines: 2,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.email),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  // Giữ viền cam khi có lỗi
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // UserName
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                onChanged: (value) {
                  final usernamePattern = RegExp(r'^[a-zA-Z0-9]{8,}$');
                  if (usernamePattern.hasMatch(value)) {
                    _usernameError = null;
                  } else {
                    _usernameError = 'Username phải ít nhất 8 ký tự, không chứa ký tự đặc biệt';
                  }
                  setState(() {});  // Đảm bảo cập nhật UI
                },
                decoration: InputDecoration(
                  labelText: "Username",
                  errorText: _usernameError,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                  errorMaxLines: 2,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.person),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  // Giữ viền cam khi có lỗi (thay vì viền đỏ mặc định)
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mật khẩu
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword1,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  if (value.length >= 8) {
                    _passwordError = null;
                  } else {
                    _passwordError = 'Mật khẩu phải có ít nhất 8 ký tự';
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _passwordError,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.lock),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //Url Hình ảnh
              TextField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  final urlPattern = RegExp(
                    r'^(https?:\/\/.*\.(?:png|jpg|jpeg|gif))$', caseSensitive: false);
                  if (value.isEmpty || urlPattern.hasMatch(value)) {
                    _imageUrlError = null;
                  } else {
                    _imageUrlError = 'Vui lòng nhập URL ảnh hợp lệ (.jpg, .png, .jpeg, .gif)';
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: "URL hình ảnh",
                  hintText: "Nhập URL hình ảnh (.jpg, .png, .jpeg, .gif)",
                  errorText: _imageUrlError,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.image),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Hướng dẫn
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Inter',
                          letterSpacing: 0.5,
                          height: 1.5,
                          ),
                        children: [
                          TextSpan(text: "Nhấn nút "),
                          TextSpan(
                            text: "Đăng ký tài khoản",
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', letterSpacing: 0.5),
                          ),
                        TextSpan(text: " bên dưới, bạn đã hoàn thành quy trình kích hoạt tài khoản mới. Tài khoản này có thể được sử dụng trên cả web xe khách của chúng tôi."),
                        ],
                      ),
                      textAlign: TextAlign.justify, // ✅ Canh đều
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              //Nút Đăng ký tài khoản
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    "Đăng ký tài khoản",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ),
    ); 
  }
}