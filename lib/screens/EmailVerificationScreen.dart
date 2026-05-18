import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plus90_application/utils/AppRoutes.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String userName;
  final String userPhone;

  const EmailVerificationScreen({
    super.key,
    required this.userName,
    required this.userPhone,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _pollingTimer;
  Timer? _cooldownTimer;

  bool _isCheckingManually = false;
  bool _isResending = false;
  int _cooldownSeconds = 0;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  // =========================================================
  // Polling كل 3 ثواني
  // =========================================================
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _checkVerification();
    });
  }

  Future<void> _checkVerification() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final fresh = FirebaseAuth.instance.currentUser;
      if (fresh != null && fresh.emailVerified && mounted) {
        _pollingTimer?.cancel();
        await _goToChoosetype();
      }
    } on FirebaseAuthException catch (e) {
      print('Polling error: ${e.code}');
    } catch (e) {
      print('Polling error: $e');
    }
  }

  // =========================================================
  // Navigation بعد التأكيد
  // =========================================================
  Future<void> _goToChoosetype() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': widget.userName,
      'email': user.email ?? '',
      'phone': widget.userPhone,
      'role': 'not_selected',
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      Approutes.Choosetype,
      (route) => false,
      arguments: {
        'name': widget.userName,
        'email': user.email ?? '',
        'phone': widget.userPhone,
      },
    );
  }

  // =========================================================
  // Manual Check مع retry 3 مرات
  // =========================================================
  Future<void> _manualCheck() async {
    if (_isCheckingManually) return;
    setState(() => _isCheckingManually = true);

    bool verified = false;

    for (int i = 0; i < 3; i++) {
      try {
        await FirebaseAuth.instance.currentUser?.reload();
        final fresh = FirebaseAuth.instance.currentUser;

        if (fresh != null && fresh.emailVerified) {
          verified = true;
          break;
        }

        if (i < 2) await Future.delayed(const Duration(seconds: 1));
      } on FirebaseAuthException catch (e) {
        if (i == 2) {
          if (mounted) {
            _showSnackbar(
              e.code == 'network-request-failed'
                  ? 'No internet connection, please check your network'
                  : 'Error: ${e.message}',
              isError: true,
            );
          }
          if (mounted) setState(() => _isCheckingManually = false);
          return;
        }
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        if (i == 2) {
          if (mounted) {
            _showSnackbar(
              'Verification failed, check your connection',
              isError: true,
            );
          }
          if (mounted) setState(() => _isCheckingManually = false);
          return;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    if (verified) {
      _pollingTimer?.cancel();
      if (mounted) await _goToChoosetype();
    } else {
      if (mounted) {
        _showSnackbar(
          'Email not verified yet. Open the link in your inbox.',
          isError: true,
        );
      }
    }

    if (mounted) setState(() => _isCheckingManually = false);
  }

  // =========================================================
  // Resend مع Cooldown
  // =========================================================
  Future<void> _resendEmail() async {
    if (_isResending || _cooldownSeconds > 0 || _user == null) return;
    setState(() => _isResending = true);

    try {
      await _user!.sendEmailVerification();
      if (mounted) {
        _showSnackbar('Verification email sent!', isError: false);
        _startCooldown(60);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        if (e.code == 'too-many-requests') {
          _showSnackbar('Too many requests, please wait a moment');
          _startCooldown(60);
        } else {
          _showSnackbar(e.message ?? 'Something went wrong');
        }
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _startCooldown(int seconds) {
    setState(() => _cooldownSeconds = seconds);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_cooldownSeconds > 0) {
          _cooldownSeconds--;
        } else {
          t.cancel();
        }
      });
    });
  }

  // =========================================================
  // Logout
  // =========================================================
  Future<void> _logout() async {
    _pollingTimer?.cancel();
    _cooldownTimer?.cancel();
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Approutes.login,
        (route) => false,
      );
    }
  }

  void _showSnackbar(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? const Color(0xff861E43)
            : const Color(0xff2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // =========================================================
  // UI
  // =========================================================
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final userEmail = _user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColor.offwhite,
      appBar: AppBar(
        backgroundColor: AppColor.offwhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _logout,
            child: Row(
              children: [
                const Icon(
                  Icons.logout_rounded,
                  color: AppColor.orange,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text('Logout', style: AppStyle.medium14orange),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: h * 0.04),

              // ── Icon ──────────────────────────────────────
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColor.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.orange.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 48,
                    color: AppColor.orange,
                  ),
                ),
              ),

              SizedBox(height: h * 0.035),

              // ── Title ─────────────────────────────────────
              Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: AppStyle.bold32black,
              ),

              SizedBox(height: h * 0.012),

              Text(
                'We sent a verification link to',
                textAlign: TextAlign.center,
                style: AppStyle.medium14ramdi,
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                textAlign: TextAlign.center,
                style: AppStyle.semibold14orange,
              ),

              SizedBox(height: h * 0.01),

              Text(
                'Open the email and tap the link.\nThis page updates automatically.',
                textAlign: TextAlign.center,
                style: AppStyle.medium14ramdi,
              ),

              SizedBox(height: h * 0.04),

              // ── Auto-checking indicator ────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.orange.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.orange.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.orange.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Checking automatically every 3 seconds...',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColor.orange.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.04),

              // ── Primary Button ─────────────────────────────
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isCheckingManually ? null : _manualCheck,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.orange,
                    disabledBackgroundColor: AppColor.orange.withOpacity(0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isCheckingManually
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Checking...',
                              style: AppStyle.semibold20white,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "I've verified, continue",
                              style: AppStyle.semibold20white,
                            ),
                          ],
                        ),
                ),
              ),

              SizedBox(height: h * 0.018),

              // ── Resend Button ──────────────────────────────
              SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: (_cooldownSeconds > 0 || _isResending)
                      ? null
                      : _resendEmail,
                  style: OutlinedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(
                      color: (_cooldownSeconds > 0 || _isResending)
                          ? AppColor.grayColor3
                          : AppColor.orange,
                      width: 1.2,
                    ),
                  ),
                  child: _isResending
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.orange.withOpacity(0.6),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_outlined,
                              size: 18,
                              color: _cooldownSeconds > 0
                                  ? AppColor.grayColor2
                                  : AppColor.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _cooldownSeconds > 0
                                  ? 'Resend in $_cooldownSeconds s'
                                  : 'Resend verification email',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _cooldownSeconds > 0
                                    ? AppColor.grayColor2
                                    : AppColor.orange,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              SizedBox(height: h * 0.035),

              // ── Tips Card ──────────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.orange.withOpacity(0.12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: AppColor.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Didn't receive the email?",
                          style: AppStyle.semibold14orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _tipRow(
                      Icons.folder_outlined,
                      'Check your Spam or Junk folder',
                    ),
                    const SizedBox(height: 8),
                    _tipRow(
                      Icons.email_outlined,
                      'Make sure you entered the correct email',
                    ),
                    const SizedBox(height: 8),
                    _tipRow(
                      Icons.timer_outlined,
                      'Wait a minute then tap "Resend"',
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tipRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColor.orange.withOpacity(0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0XFF6B6B6B),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
