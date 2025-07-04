-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT,
    username TEXT UNIQUE,
    email TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create journal_entries table
CREATE TABLE IF NOT EXISTS public.journal_entries (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create mood_entries table
CREATE TABLE IF NOT EXISTS public.mood_entries (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    mood TEXT NOT NULL,
    detailed_mood TEXT,
    note TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create articles table (for admin to manage articles)
CREATE TABLE IF NOT EXISTS public.articles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    image_url TEXT,
    author_id UUID REFERENCES public.profiles(id),
    published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create meditation_sessions table
CREATE TABLE IF NOT EXISTS public.meditation_sessions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    duration_minutes INTEGER NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create music_preferences table
CREATE TABLE IF NOT EXISTS public.music_preferences (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    song_name TEXT NOT NULL,
    artist TEXT,
    genre TEXT,
    is_favorite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Set up Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.journal_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mood_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meditation_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.music_preferences ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Create policies for journal_entries
CREATE POLICY "Users can view own journal entries" ON public.journal_entries
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own journal entries" ON public.journal_entries
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own journal entries" ON public.journal_entries
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own journal entries" ON public.journal_entries
    FOR DELETE USING (auth.uid() = user_id);

-- Create policies for mood_entries
CREATE POLICY "Users can view own mood entries" ON public.mood_entries
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own mood entries" ON public.mood_entries
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own mood entries" ON public.mood_entries
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own mood entries" ON public.mood_entries
    FOR DELETE USING (auth.uid() = user_id);

-- Create policies for articles (read-only for all authenticated users)
CREATE POLICY "Authenticated users can view published articles" ON public.articles
    FOR SELECT USING (auth.role() = 'authenticated' AND published = true);

-- Create policies for meditation_sessions
CREATE POLICY "Users can view own meditation sessions" ON public.meditation_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own meditation sessions" ON public.meditation_sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own meditation sessions" ON public.meditation_sessions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own meditation sessions" ON public.meditation_sessions
    FOR DELETE USING (auth.uid() = user_id);

-- Create policies for music_preferences
CREATE POLICY "Users can view own music preferences" ON public.music_preferences
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own music preferences" ON public.music_preferences
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own music preferences" ON public.music_preferences
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own music preferences" ON public.music_preferences
    FOR DELETE USING (auth.uid() = user_id);

-- Create function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, email, created_at)
    VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically create profile
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_journal_entries_updated_at
    BEFORE UPDATE ON public.journal_entries
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_mood_entries_updated_at
    BEFORE UPDATE ON public.mood_entries
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_articles_updated_at
    BEFORE UPDATE ON public.articles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Insert some sample articles
INSERT INTO public.articles (title, content, excerpt, image_url, published) VALUES
('Apa itu Depresi? Ketahui Gejalanya!', 
 'Depresi adalah gangguan mood yang menyebabkan perasaan sedih yang persisten dan kehilangan minat dalam aktivitas. Artikel ini membahas gejala-gejala depresi yang perlu diketahui...', 
 'Mengenali gejala-gejala depresi untuk pencegahan dan penanganan yang tepat.',
 'https://storage.googleapis.com/a1aa/image/f9cbd776-fd31-42aa-2239-803f1ec8488e.jpg',
 true),
('Tips Untuk Menenangkan Diri',
 'Dalam kehidupan sehari-hari, stres dan kecemasan adalah hal yang wajar. Namun, penting untuk memiliki strategi yang efektif untuk menenangkan diri...',
 'Berbagai teknik dan tips praktis untuk mengelola stres dan menenangkan pikiran.',
 'https://storage.googleapis.com/a1aa/image/9390b3be-4732-40ef-ce92-f9026e4db302.jpg',
 true),
('Tips Untuk Menjaga Kesehatan Mental',
 'Kesehatan mental sama pentingnya dengan kesehatan fisik. Artikel ini memberikan tips praktis untuk menjaga kesehatan mental dalam kehidupan sehari-hari...',
 'Panduan lengkap untuk menjaga kesehatan mental dan meningkatkan kualitas hidup.',
 'https://storage.googleapis.com/a1aa/image/27ea1813-2789-4033-68cf-bf0d0d8c8d68.jpg',
 true); 