import 'package:flutter/material.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/l10n/app_localizations.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  String? licenceFrontUrl;
  String? licenceBackUrl;
  String? aadharFront;
  String? aadharBack;
  @override
  void initState() {
    super.initState();
    _loadDocs();
  }

  Future<void> _loadDocs() async {
    licenceFrontUrl = await SharedPrefServices.getlicenceFront() ?? '';
    licenceBackUrl = await SharedPrefServices.getlicenceBack() ?? '';
    aadharFront = await SharedPrefServices.getaadharFront() ?? '';
    aadharBack = await SharedPrefServices.getaadharBack() ?? '';
    setState(() {});
  }

  void _openLicenceFolder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LicenceDetailPage(
          frontUrl: licenceFrontUrl,
          backUrl: licenceBackUrl,
        ),
      ),
    );
  }

  void _openaadhar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AadharDetails(frontUrl: aadharFront, backUrl: aadharBack),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "images/chevronLeft.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: localizations.documents,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.folder,
                    color: Colors.orange,
                    size: 32,
                  ),
                  title: Text(localizations.drivingLicence),
                  subtitle: Text(
                    (licenceFrontUrl?.isNotEmpty ?? false) ||
                            (licenceBackUrl?.isNotEmpty ?? false)
                        ? localizations.uploaded
                        : localizations.notUploaded,
                    style: TextStyle(
                      color: (licenceFrontUrl?.isNotEmpty ?? false)
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _openLicenceFolder,
                ),

                SizedBox(height: 10),
                ListTile(
                  leading: const Icon(
                    Icons.folder,
                    color: Colors.orange,
                    size: 32,
                  ),
                  title: Text(localizations.aadharCard),
                  subtitle: Text(
                    (aadharFront?.isNotEmpty ?? false) ||
                            (aadharBack?.isNotEmpty ?? false)
                        ? localizations.uploaded
                        : localizations.notUploaded,
                    style: TextStyle(
                      color: (aadharBack?.isNotEmpty ?? false)
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _openaadhar,
                ),
              ],
            ),
          ),

          // SafeArea(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: SizedBox(
          //       width: 250,
          //       child: ElevatedButton.icon(
          //         style: ElevatedButton.styleFrom(
          //           padding: const EdgeInsets.symmetric(vertical: 14),
          //           backgroundColor: korangeColor,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(30),
          //           ),
          //         ),
          //         onPressed: () {},
          //         icon: const Icon(Icons.upload, color: Colors.white),
          //         label: const Text(
          //           "Upload Document",
          //           style: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class LicenceDetailPage extends StatelessWidget {
  final String? frontUrl;
  final String? backUrl;

  const LicenceDetailPage({super.key, this.frontUrl, this.backUrl});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      "images/chevronLeft.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: localizations.drivingLicence,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            _buildLicenceCard(
              title: "",
              imageUrl: frontUrl,
              failed: localizations.failedToLoadImage,
              noimage: localizations.noImageAvailable,
            ),
            const SizedBox(height: 20),

            _buildLicenceCard(
              title: "",
              imageUrl: backUrl,
              failed: localizations.failedToLoadImage,
              noimage: localizations.noImageAvailable,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenceCard({
    required String title,
    String? imageUrl,
    required String failed,
    required String noimage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: KorangeColorNew,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: Center(child: Text(failed)),
                    );
                  },
                )
              : Container(
                  height: 200,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: Text(noimage, style: TextStyle(color: Colors.grey)),
                  ),
                ),
        ),
      ],
    );
  }
}

class AadharDetails extends StatelessWidget {
  final String? frontUrl;
  final String? backUrl;

  const AadharDetails({super.key, this.frontUrl, this.backUrl});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      "images/chevronLeft.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: localizations.aadharCard,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            _buildLicenceCard(
              title: "",
              imageUrl: frontUrl,
              failed: localizations.failedToLoadImage,
              noimage: localizations.noImageAvailable,
            ),
            const SizedBox(height: 20),

            _buildLicenceCard(
              title: "",
              imageUrl: backUrl,
              failed: localizations.failedToLoadImage,
              noimage: localizations.noImageAvailable,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenceCard({
    required String title,
    String? imageUrl,
    required String failed,
    required String noimage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: KorangeColorNew,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: Center(child: Text(failed)),
                    );
                  },
                )
              : Container(
                  height: 200,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: Text(noimage, style: TextStyle(color: Colors.grey)),
                  ),
                ),
        ),
      ],
    );
  }
}
