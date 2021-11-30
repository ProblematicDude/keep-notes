import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({final Key? key}) : super(key: key);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with TickerProviderStateMixin {
  @override
  Widget build(final BuildContext context) => body(context);

  Widget body(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  launchUrl(context, githubProfile);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  child: SvgPicture.asset(me),
                ),
              ),
            ),
            const Divider(
                height: 60, color: Colors.black, indent: 12, endIndent: 12),
            Text(
              Language.of(context).name,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Product Sans',
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
            const SizedBox(height: 30),
            Text(
              Language.of(context).devName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              Language.of(context).email,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Product Sans',
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
            const SizedBox(height: 30),
            Row(
              children: <Widget>[
                const Icon(Icons.email),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () => goToBugScreen(context),
                  child: Text(
                    'nikhildevelops@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
                height: 60, color: Colors.black, indent: 12, endIndent: 12),
            Container(
              margin: const EdgeInsets.only(left: 16, top: 8),
              child: Center(
                child: Text(
                  Language.of(context).social,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Product Sans',
                      color: Theme.of(context).textTheme.bodyText1!.color),
                ),
              ),
            ),
            const SocialLinksRow(),
            const SizedBox(height: 16),
            const Divider(
                height: 60, color: Colors.black, indent: 12, endIndent: 12),
          ],
        ),
      ),
    );
  }
}
