import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_strings.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isdarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
      appBar: AppBar(
        backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.angle_left, color: textPrimaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    'assets/images/DonnaGif.gif',
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  width: 50,
                  height: 170,
                  child: Image.asset(
                    'assets/images/ScrollGif.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildTitle(textTitleWelcome),
            _buildParagraph(textParagraphWelcome),
            Divider(color: Colors.white),
            _buildSubtitle(textSubtitleFeatures),
            _buildFeature(textFeatureCustomModelsTitle, textFeatureCustomModelsDescription),
            _buildFeature(textFeatureIntuitiveInterfaceTitle, textFeatureIntuitiveInterfaceDescription),
            _buildFeature(textFeatureRealTimeChatTitle, textFeatureRealTimeChatDescription),
            _buildFeature(textFeatureSecurityPrivacyTitle, textFeatureSecurityPrivacyDescription),
            Divider(color: Colors.white),
            _buildSubtitle(textSubtitleWhyChoose),
            _buildFeature(textFeatureExtremeCustomizationTitle, textFeatureExtremeCustomizationDescription),
            _buildFeature(textFeatureEaseOfUseTitle, textFeatureEaseOfUseDescription),
            _buildFeature(textFeatureContinuousSupportTitle, textFeatureContinuousSupportDescription),
            Divider(color: Colors.white),
            _buildParagraph(textParagraphJoinUs),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildFeature(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.white),
          children: [
            TextSpan(
              text: '• $title: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
