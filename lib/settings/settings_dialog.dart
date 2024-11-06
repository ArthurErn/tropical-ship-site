import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/client/register_client_dialog.dart';
import 'package:tropical_ship_supply/product/register_product_dialog.dart';
import 'package:tropical_ship_supply/settings/currency/register_currency_dialog.dart';
import 'package:tropical_ship_supply/settings/payment-terms/register_payment_terms_dialog.dart';
import 'package:tropical_ship_supply/upload/upload_file_dialog.dart';
import 'package:tropical_ship_supply/user/register_user_dialog.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Center(
        child: Text(
          'Configurações',
          style: TextStyle(
            color: AppColors().blueColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      content: SizedBox(
        width: 250,
        child: GridView(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.2, // Ajuste aqui
          ),
          children: [
            _buildGridButton(
              context,
              icon: Icons.person_add,
              label: 'Cadastrar usuário',
              onPressed: () {
                registerUser(context);
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.group_add,
              label: 'Cadastrar cliente',
              onPressed: () {
                registerClient(context);
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.attach_money,
              label: 'Cadastrar moeda',
              onPressed: () {
                registerCurrency(context);
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.add_box,
              label: 'Cadastrar produto',
              onPressed: () {
                registerProduct(context, (_) {});
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.payment,
              label: 'Cadastrar termos de pagamento',
              onPressed: () {
                registerPaymentTerms(context);
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.upload_file,
              label: 'Upload embarcações',
              onPressed: () {
                uploadFile(
                  context,
                  (_) {},
                  isProduct: false,
                );
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.upload_file,
              label: 'Upload produtos',
              onPressed: () {
                uploadFile(context, (_) {});
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Fechar',
            style: TextStyle(color: AppColors().blueColor),
          ),
        ),
      ],
    );
  }

  Widget _buildGridButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors().blueColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors().blueColor,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              style: TextStyle(
                color: AppColors().blueColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
