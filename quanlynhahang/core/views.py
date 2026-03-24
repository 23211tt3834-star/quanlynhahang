from django.shortcuts import render, redirect, get_object_or_404
from .models import MonAn, LoaiMon  
from .models import Ban, DatBan, DonHang
from django.http import HttpResponse
from django.contrib import messages
from datetime import datetime, timedelta
from django.contrib.auth.decorators import user_passes_test

from django.shortcuts import redirect

def trang_chu(request):
    danh_sach_loai = LoaiMon.objects.all()
    danh_sach_mon = MonAn.objects.all()
    
    context = {
        'danh_sach_loai': danh_sach_loai,
        'danh_sach_mon': danh_sach_mon
    }
    return render(request, 'trang_chu.html', context)

def chi_tiet_mon(request, mon_id):
    mon = get_object_or_404(MonAn, id=mon_id)
    return render(request, 'chi_tiet_mon.html', {'mon': mon})

def redirect_after_login(request):
    if request.user.is_staff:   # admin
        return redirect('/admin')
    else:                       # user thường
        return redirect('/')
    
def dat_ban_view(request):
    if request.method == 'POST':
        ten_khach = request.POST.get('ten_khach_hang')
        sdt = request.POST.get('so_dien_thoai')
        ngay = request.POST.get('ngay_dat')      
        gio_str = request.POST.get('gio_dat')     
        so_nguoi = int(request.POST.get('so_nguoi'))
        ghi_chu = request.POST.get('ghi_chu', '')

        thoi_gian_dat = datetime.strptime(f"{ngay} {gio_str}", "%Y-%m-%d %H:%M")
        gio_bat_dau = (thoi_gian_dat - timedelta(hours=2)).time()
        gio_ket_thuc = (thoi_gian_dat + timedelta(hours=2)).time()

        ban_dang_ban = DatBan.objects.filter(
            ngay_dat=ngay,
            gio_dat__range=(gio_bat_dau, gio_ket_thuc),
            ban__isnull=False 
        ).values_list('ban_id', flat=True)

        ban_trong = Ban.objects.filter(so_ghe__gte=so_nguoi).exclude(id__in=ban_dang_ban).first()

        if ban_trong:
            DatBan.objects.create(
                ten_khach_hang=ten_khach,
                so_dien_thoai=sdt,
                ngay_dat=ngay,
                gio_dat=gio_str,
                so_nguoi=so_nguoi,
                ghi_chu=ghi_chu,
                ban=ban_trong, 
                trang_thai='ChoXacNhan'
            )
            
            ban_trong.trang_thai = 'Đã đặt' 
            ban_trong.save()

            messages.success(request, f'Đặt bàn thành công! Hệ thống đã giữ {ban_trong.so_ban} cho bạn.')
            return redirect('trang_chu') 
        else:
            messages.error(request, 'Rất tiếc, nhà hàng đã hết bàn trống đủ chỗ vào khung giờ này. Quý khách vui lòng chọn giờ khác!')
            return redirect('dat_ban') 

    return render(request, 'dat_ban.html')
        

def thanh_toan_view(request, dat_ban_id):
    don = get_object_or_404(DatBan, id=dat_ban_id)
    
    if request.method == 'POST':
        don.trang_thai = 'DaCoc' 
        don.save()
        return HttpResponse(f"<h2> Đặt bàn thành công!</h2> <p>Cảm ơn {don.ten_khach_hang}. Bàn của bạn (ID: {don.id}) đã được giữ.</p>")
        
    return render(request, 'thanh_toan.html', {'don': don})


def kiem_tra_nhan_vien(user):
    return user.is_authenticated and user.is_staff

@user_passes_test(kiem_tra_nhan_vien, login_url='/admin/login/')
def man_hinh_nhan_vien(request):
    
    danh_sach_ban = Ban.objects.all().order_by('so_ban')
    
    don_hang_dang_cho = DonHang.objects.exclude(trang_thai_don='Da_thanh_toan').order_by('-thoi_gian_tao')

    context = {
        'danh_sach_ban': danh_sach_ban,
        'don_hang_dang_cho': don_hang_dang_cho,
    }
    return render(request, 'nhan_vien/dashboard.html', context)