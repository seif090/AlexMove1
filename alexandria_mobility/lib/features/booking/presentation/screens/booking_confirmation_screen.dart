import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/booking_provider.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final int groupId;
  final String groupName;
  final String? pickupLocation;
  final String? dropoffLocation;
  final double? price;
  final int seats;
  final String? bookingDate;

  const BookingConfirmationScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    this.pickupLocation,
    this.dropoffLocation,
    this.price,
    this.seats = 1,
    this.bookingDate,
  });

  @override
  ConsumerState<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends ConsumerState<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isBooked = false;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSuccessAnimation() {
    setState(() => _isBooked = true);
    _animationController.forward();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Select date';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, MMM d, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return '--';
    return '${amount.toStringAsFixed(0)} EGP';
  }

  double _calculateTotal() {
    return (widget.price ?? 0) * widget.seats;
  }

  Future<void> _handleBookNow() async {
    if (_isBooking) return;

    setState(() => _isBooking = true);

    final date = widget.bookingDate ?? DateTime.now().toIso8601String().split('T')[0];

    final success = await ref.read(createBookingProvider.notifier).createBooking(
      groupId: widget.groupId,
      bookingDate: date,
      pickupLocation: widget.pickupLocation,
      dropoffLocation: widget.dropoffLocation,
      seats: widget.seats,
    );

    setState(() => _isBooking = false);

    if (success && mounted) {
      _showSuccessAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final createBookingState = ref.watch(createBookingProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          _isBooked ? 'Booking Confirmed' : 'Confirm Booking',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        leading: _isBooked
            ? IconButton(
                onPressed: () {
                  context.go('/bookings');
                },
                icon: const Icon(Icons.close_rounded),
              )
            : null,
      ),
      body: _isBooked ? _buildSuccessView() : _buildConfirmationView(createBookingState),
    );
  }

  Widget _buildConfirmationView(AsyncValue<dynamic> createBookingState) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTripSummaryCard(),
                const SizedBox(height: 16),
                _buildRouteCard(),
                const SizedBox(height: 16),
                _buildPriceCard(),
              ],
            ),
          ),
        ),
        _buildBottomBar(createBookingState),
      ],
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Group',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      widget.groupName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(widget.bookingDate),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.event_seat_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.seats} seat${widget.seats > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.pickupLocation != null) ...[
            _buildLocationRow(
              icon: Icons.trip_origin_rounded,
              label: 'Pickup',
              location: widget.pickupLocation!,
              color: AppColors.success,
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.only(left: 11),
              width: 2,
              height: 20,
              color: AppColors.lightBorder,
            ),
            const SizedBox(height: 12),
          ],
          if (widget.dropoffLocation != null)
            _buildLocationRow(
              icon: Icons.trip_origin_rounded,
              label: 'Drop-off',
              location: widget.dropoffLocation!,
              color: AppColors.danger,
            ),
          if (widget.pickupLocation == null && widget.dropoffLocation == null)
            const Text(
              'No route specified',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String location,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurfaceVariant,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard() {
    final total = _calculateTotal();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            label: 'Price per seat',
            value: _formatCurrency(widget.price),
          ),
          if (widget.seats > 1) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              label: 'Seats',
              value: '× ${widget.seats}',
            ),
          ],
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: AppColors.lightBorder,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurface,
                ),
              ),
              Text(
                _formatCurrency(total),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Cairo',
            color: AppColors.lightOnSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
            color: AppColors.lightOnSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(AsyncValue<dynamic> createBookingState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightOnSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: (_isBooking || createBookingState.isLoading) ? null : _handleBookNow,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: (_isBooking || createBookingState.isLoading)
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.success,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Opacity(
                  opacity: _opacityAnimation.value,
                  child: Column(
                    children: [
                      const Text(
                        'Booking Confirmed!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                          color: AppColors.lightOnSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your seat in ${widget.groupName} has been reserved successfully.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Cairo',
                          color: AppColors.lightOnSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => context.go('/bookings'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'View My Bookings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.go('/'),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            color: AppColors.lightOnSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
