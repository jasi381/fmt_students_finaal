import 'package:flutter/material.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController(text: "sjasmeet438@gmail.com");

  TextEditingController phone = TextEditingController();

  TextEditingController address = TextEditingController();

  TextEditingController state = TextEditingController();

  TextEditingController city = TextEditingController();

  TextEditingController pincode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const PoppinsText(
          text: "Edit Profile",
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(name,'Full Name', 'Name',TextInputAction.next,false),
            _buildInputField(email,'Email', 'Email',TextInputAction.next,true),
            _buildInputField(phone,'Phone Number', 'Phone Number',TextInputAction.next,false),
            _buildInputField(address,'Address', 'Address',TextInputAction.next, maxLines: 3,false),
            _buildInputField(state,'State', 'State',TextInputAction.next,false),
            Row(
              children: [
                Expanded(child: _buildInputField(city,'City', 'City',TextInputAction.next,false)),
                const SizedBox(width: 16),
                Expanded(child: _buildInputField(pincode,'Pincode', 'Pincode',TextInputAction.done,false)),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom,)
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller,
      String label,
      String hint,
      TextInputAction inputAction,
      bool readOnly,
      {int maxLines = 1}
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            textInputAction: inputAction,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}